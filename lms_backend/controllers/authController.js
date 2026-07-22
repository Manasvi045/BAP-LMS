const pool = require("../config/db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const generateToken = require("../utils/generateToken"); // Make sure this utility accepts the user ID

const {
    validateFullName,
    validateEmail,
    validatePassword
} = require("../utils/validation");

const registerUser = async (req, res) => {
    try {
        const { fullName, email, password } = req.body;

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

        const passResult = validatePassword(password);
        if (!passResult.ok) {
            return res.status(400).json({
                success: false,
                message: passResult.message
            });
        }

        // Check if email already exists
        const existingUser = await pool.query(
            "SELECT id FROM users WHERE email = $1",
            [emailResult.value]
        );

        if (existingUser.rows.length > 0) {
            return res.status(409).json({
                success: false,
                message: "Email already exists"
            });
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(passResult.value, 10);

        // Insert user
        const newUser = await pool.query(
            `INSERT INTO users
            (
                full_name,
                email,
                password,
                role,
                must_change_password,
                is_active,
                created_at,
                updated_at
            )
            VALUES
            (
                $1,
                $2,
                $3,
                'user',
                TRUE,
                TRUE,
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP
            )
            RETURNING
                id,
                full_name,
                email,
                role,
                must_change_password,
                is_active,
                created_at,
                updated_at`,
            [
                nameResult.value,
                emailResult.value,
                hashedPassword
            ]
        );

        res.status(201).json({
            success: true,
            message: "User registered successfully",
            user: newUser.rows[0]
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server Error"
        });
    }
};

const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        const emailResult = validateEmail(email);
        if (!emailResult.ok) {
            return res.status(400).json({
                success: false,
                message: emailResult.message
            });
        }

        if (typeof password !== "string" || password.length === 0) {
            return res.status(400).json({
                success: false,
                message: "password is required"
            });
        }

        const result = await pool.query(
            "SELECT * FROM users WHERE email = $1",
            [emailResult.value]
        );

        if (result.rows.length === 0) {
            return res.status(401).json({
                success: false,
                message: "Invalid email or password"
            });
        }

        const user = result.rows[0];

        const isPasswordCorrect = await bcrypt.compare(
            password,
            user.password
        );

        if (!isPasswordCorrect) {
            return res.status(401).json({
                success: false,
                message: "Invalid email or password"
            });
        }

        const token = generateToken(user);

        return res.status(200).json({
            success: true,
            message: "Login successful",
            token,
            mustChangePassword: user.must_change_password,
            user: {
                id: user.id,
                fullName: user.full_name,
                email: user.email,
                role: user.role,
            },
        });

    } catch (error) {
        console.error(error);

        return res.status(500).json({
            success: false,
            message: "Server Error"
        });
    }
};


const changePassword = async (req, res) => {
    try {
        const { currentPassword, newPassword, confirmPassword } = req.body;

        if (typeof currentPassword !== "string" || currentPassword.length === 0) {
            return res.status(400).json({
                success: false,
                message: "currentPassword is required"
            });
        }

        const newPassResult = validatePassword(newPassword, "newPassword");
        if (!newPassResult.ok) {
            return res.status(400).json({
                success: false,
                message: newPassResult.message
            });
        }

        if (typeof confirmPassword !== "string" || confirmPassword.length === 0) {
            return res.status(400).json({
                success: false,
                message: "confirmPassword is required"
            });
        }

        // Check if new passwords match
        if (newPassword !== confirmPassword) {
            return res.status(400).json({
                success: false,
                message: "New password and confirm password do not match"
            });
        }

        // Get logged-in user from JWT
        const userResult = await pool.query(
            "SELECT * FROM users WHERE id = $1",
            [req.user.id]
        );

        if (userResult.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: "User not found"
            });
        }

        const user = userResult.rows[0];

        // Verify current password
        const isPasswordCorrect = await bcrypt.compare(
            currentPassword,
            user.password
        );

        if (!isPasswordCorrect) {
            return res.status(401).json({
                success: false,
                message: "Current password is incorrect"
            });
        }

        // Hash new password
        const hashedPassword = await bcrypt.hash(newPassword, 10);

        // Update password and disable first-login requirement
        await pool.query(
            `UPDATE users
             SET password = $1,
                 must_change_password = FALSE
             WHERE id = $2`,
            [hashedPassword, user.id]
        );

        return res.status(200).json({
            success: true,
            message: "Password changed successfully"
        });

    } catch (error) {
        console.error(error);

        return res.status(500).json({
            success: false,
            message: "Server Error"
        });
    }
};

module.exports = {
    registerUser,
    loginUser, changePassword
};