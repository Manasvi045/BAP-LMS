const db = require("../config/db");
const bcrypt = require("bcrypt");
const generatePassword = require("../utils/generatePassword");

const {
    validateFullName,
    validateEmail,
    validateUserId,
    validateBoolean,
    validateOptionalString,
    validateSearch,
    validateRoleFilter,
    validateStatusFilter,
    validatePage,
    validateLimit,
    validateRole
} = require("../utils/validation");

const getAllUsers = async (req, res) => {
    try {
        const searchResult = validateSearch(req.query.search);
        if (!searchResult.ok) {
            return res.status(400).json({
                success: false,
                message: searchResult.message
            });
        }

        const roleFilterResult = validateRoleFilter(req.query.role);
        if (!roleFilterResult.ok) {
            return res.status(400).json({
                success: false,
                message: roleFilterResult.message
            });
        }

        const statusFilterResult = validateStatusFilter(req.query.status);
        if (!statusFilterResult.ok) {
            return res.status(400).json({
                success: false,
                message: statusFilterResult.message
            });
        }

        const pageResult = validatePage(req.query.page);
        if (!pageResult.ok) {
            return res.status(400).json({
                success: false,
                message: pageResult.message
            });
        }

        const limitResult = validateLimit(req.query.limit);
        if (!limitResult.ok) {
            return res.status(400).json({
                success: false,
                message: limitResult.message
            });
        }

        const search = searchResult.value;
        const role = roleFilterResult.value;
        const status = statusFilterResult.value;
        const page = pageResult.value;
        const limit = limitResult.value;

        let query = `
    SELECT
        id,
        full_name,
        email,
        role,
        must_change_password,
        is_active,
        created_at,
        updated_at
    FROM users
`;

        const conditions = [];
        const values = [];
        let index = 1;

        if (search) {
            conditions.push(`(full_name ILIKE $${index} OR email ILIKE $${index})`);
            values.push(`%${search}%`);
            index++;
        }

        if (role) {
            conditions.push(`role = $${index}`);
            values.push(role);
            index++;
        }

        if (status === "active") {
            conditions.push(`is_active = $${index}`);
            values.push(true);
            index++;
        } else if (status === "inactive") {
            conditions.push(`is_active = $${index}`);
            values.push(false);
            index++;
        }

        if (conditions.length > 0) {
            query += " WHERE " + conditions.join(" AND ");
        }

        const countQuery = `
    SELECT COUNT(*) AS total
    FROM users
    ${conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : ""}
`;

        const countResult = await db.query(
            countQuery,
            [...values]
        );

        const totalRecords = Number(countResult.rows[0].total);
        const totalPages = Math.ceil(totalRecords / limit);

        const hasNextPage = page < totalPages;
        const hasPrevPage = page > 1;
        const nextPage = hasNextPage ? page + 1 : null;
        const prevPage = hasPrevPage ? page - 1 : null;

        query += " ORDER BY created_at DESC";

        const offset = (page - 1) * limit;

        query += ` LIMIT $${index} OFFSET $${index + 1}`;

        values.push(limit);
        values.push(offset);

        const result = await db.query(query, values);

        res.status(200).json({
            success: true,
            pagination: {
                page,
                limit,
                totalRecords,
                totalPages,
                hasNextPage,
                hasPrevPage,
                nextPage,
                prevPage
            },
            data: result.rows
        });

    } catch (error) {
        console.error("Get Users Error:", error);
        res.status(500).json({
            success: false,
            message: "Server Error"
        });
    }
};


const getUserById = async (req, res) => {
    try {
        const { id } = req.params;

        const idResult = validateUserId(id);
        if (!idResult.ok) {
            return res.status(400).json({
                success: false,
                message: idResult.message
            });
        }

        const userId = idResult.value;
        const result = await db.query(
            `
            SELECT
                id,
                full_name,
                email,
                role,
                must_change_password,
                is_active,
                created_at,
                updated_at
            FROM users
            WHERE id = $1
            `,
            [userId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: "User not found"
            });
        }

        res.status(200).json({
            success: true,
            data: result.rows[0]
        });

    } catch (error) {
        console.error("Get User By ID Error:", error);

        res.status(500).json({
            success: false,
            message: "Internal Server Error"
        });
    }
};

const updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        const { fullName, email, role } = req.body;

        const idResult = validateUserId(id);
        if (!idResult.ok) {
            return res.status(400).json({
                success: false,
                message: idResult.message
            });
        }
        const userId = idResult.value;

        const nameResult = validateFullName(fullName);
        if (!nameResult.ok) {
            return res.status(400).json({
                success: false,
                message: nameResult.message
            });
        }

        const emailResult = validateEmail(email);
        if (!emailResult.ok) {
            return res.status(400).json({
                success: false,
                message: emailResult.message
            });
        }

        // Role is OPTIONAL on update — if present, validate and apply. If
        // absent, leave the existing role untouched. This keeps the API
        // backward-compatible with clients that only send name+email.
        let nextRole = null;
        if (role !== undefined && role !== null && role !== "") {
            const roleResult = validateRole(role);
            if (!roleResult.ok) {
                return res.status(400).json({
                    success: false,
                    message: roleResult.message
                });
            }
            nextRole = roleResult.value;
        }

        const existing = await db.query(
            "SELECT id, role FROM users WHERE id = $1",
            [userId]
        );
        if (existing.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: "User not found"
            });
        }

        // Last-admin guard on role demotion. If we're about to demote an
        // admin to editor/user, ensure at least one other active admin
        // remains. Same rule the status-toggle uses.
        if (nextRole && nextRole !== "admin" && existing.rows[0].role === "admin") {
            const adminCount = await db.query(
                "SELECT COUNT(*)::int AS n FROM users WHERE role = $1 AND is_active = TRUE",
                ["admin"]
            );
            if (adminCount.rows[0].n <= 1) {
                return res.status(409).json({
                    success: false,
                    message: "Cannot demote the last active admin"
                });
            }
        }

        const conflict = await db.query(
            "SELECT id FROM users WHERE email = $1 AND id <> $2",
            [emailResult.value, userId]
        );
        if (conflict.rows.length > 0) {
            return res.status(409).json({
                success: false,
                message: "Email already in use"
            });
        }

        // Build dynamic SET clause. Always update name + email; update
        // role only when caller supplied one.
        const setClauses = [
            "full_name = $1",
            "email = $2",
            "updated_at = CURRENT_TIMESTAMP",
        ];
        const values = [nameResult.value, emailResult.value];
        if (nextRole) {
            values.push(nextRole);
            setClauses.push(`role = $${values.length}`);
        }
        values.push(userId);

        const result = await db.query(
            `UPDATE users
             SET ${setClauses.join(", ")}
             WHERE id = $${values.length}
             RETURNING
                 id,
                 full_name,
                 email,
                 role,
                 must_change_password,
                 is_active,
                 created_at,
                 updated_at`,
            values
        );

        return res.status(200).json({
            success: true,
            data: result.rows[0]
        });

    } catch (error) {
        console.error("Update User Error:", error);
        return res.status(500).json({
            success: false,
            message: "Server Error"
        });
    }
};

const updateUserStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { isActive } = req.body;

        const idResult = validateUserId(id);
        if (!idResult.ok) {
            return res.status(400).json({
                success: false,
                message: idResult.message
            });
        }
        const userId = idResult.value;

        const boolResult = validateBoolean(isActive, "isActive");
        if (!boolResult.ok) {
            return res.status(400).json({
                success: false,
                message: boolResult.message
            });
        }

        const existing = await db.query(
            "SELECT id, role, is_active FROM users WHERE id = $1",
            [userId]
        );
        if (existing.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: "User not found"
            });
        }

        const target = existing.rows[0];

        // Deactivation guards. Order matters:
        //   1) Last-admin guard — do not leave the system with zero active admins.
        //   2) Self-protection — an admin cannot deactivate their own account.
        // Last-admin runs first so the 409 path is reachable for the most
        // critical case (last admin trying to step down).
        if (isActive === false) {
            if (target.role === "admin" && target.is_active === true) {
                const adminCount = await db.query(
                    "SELECT COUNT(*)::int AS n FROM users WHERE role = $1 AND is_active = TRUE",
                    ["admin"]
                );
                if (adminCount.rows[0].n <= 1) {
                    return res.status(409).json({
                        success: false,
                        message: "Cannot deactivate the last active admin"
                    });
                }
            }

            if (req.user && req.user.id === userId) {
                return res.status(403).json({
                    success: false,
                    message: "You cannot deactivate your own account"
                });
            }
        }

        const result = await db.query(
            `UPDATE users
             SET is_active = $1,
                 updated_at = CURRENT_TIMESTAMP
             WHERE id = $2
             RETURNING
                 id,
                 full_name,
                 email,
                 role,
                 must_change_password,
                 is_active,
                 created_at,
                 updated_at`,
            [isActive, userId]
        );

        return res.status(200).json({
            success: true,
            data: result.rows[0]
        });

    } catch (error) {
        console.error("Update User Status Error:", error);
        return res.status(500).json({
            success: false,
            message: "Server Error"
        });
    }
};

const resetUserPassword = async (req, res) => {
    try {
        const { id } = req.params;
        let { newPassword } = req.body;

        const idResult = validateUserId(id);
        if (!idResult.ok) {
            return res.status(400).json({
                success: false,
                message: idResult.message
            });
        }
        const userId = idResult.value;

        const optStrResult = validateOptionalString(newPassword, "newPassword");
        if (!optStrResult.ok) {
            return res.status(400).json({
                success: false,
                message: optStrResult.message
            });
        }
        newPassword = optStrResult.value;

        const existingUser = await db.query(
            "SELECT id, email FROM users WHERE id = $1",
            [userId]
        );

        if (existingUser.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: "User not found"
            });
        }

        // Auto-generate password if admin didn't provide one
        if (!newPassword || newPassword.trim() === "") {
            newPassword = generatePassword();
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);

        await db.query(
            `UPDATE users
             SET password = $1,
                 must_change_password = TRUE,
                 updated_at = CURRENT_TIMESTAMP
             WHERE id = $2`,
            [hashedPassword, userId]
        );

        return res.status(200).json({
            success: true,
            message: "Password reset successfully",
            temporaryPassword: newPassword
        });

    } catch (error) {
        console.error("Reset User Password Error:", error);
        return res.status(500).json({
            success: false,
            message: "Server Error"
        });
    }
};

module.exports = {
    getAllUsers,
    getUserById,
    updateUser,
    updateUserStatus,
    resetUserPassword
};