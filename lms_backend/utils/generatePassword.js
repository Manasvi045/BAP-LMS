const crypto = require("crypto");

const generatePassword = (length = 10) => {

    const characters =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%";

    let password = "";

    for (let i = 0; i < length; i++) {
        const randomIndex = crypto.randomInt(0, characters.length);
        password += characters[randomIndex];
    }

    return password;
};

module.exports = generatePassword;