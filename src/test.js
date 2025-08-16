const bcrypt = require("bcryptjs");

const plain = "1111111111";
const storedHash = "$2a$10$4gEzBebN1JwNgDNEXn0ST.5b5QbE8cwOBVohPHJilpIsZjGS2vR1S"; // Paste exact value from DB

bcrypt.compare(plain, storedHash).then(result => {
  console.log("✅ Does it match?", result);
});