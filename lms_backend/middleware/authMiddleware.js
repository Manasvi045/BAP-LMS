const jwt = require("jsonwebtoken");

const authenticate = (req, res, next) => {

    // Read Authorization Header
    const authHeader = req.headers.authorization;

    // Check if token exists
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return res.status(401).json({
            success: false,
            message: "Access denied. No token provided."
        });
    }

    try {

        // Extract Token
        const token = authHeader.split(" ")[1];

        // Verify Token
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        // Attach user information to request
        req.user = decoded;

        // Continue
        next();

    } catch (error) {

        return res.status(401).json({
            success: false,
            message: "Invalid or expired token"
        });

    }

};

module.exports = authenticate;