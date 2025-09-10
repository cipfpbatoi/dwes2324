<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulari de Registre</title>
</head>
<body>
<form action="register.php" method="post">
    <div>
        <label for="nick">Nick:</label>
        <input type="text" id="nick" name="nick" required>
    </div>

    <div>
        <label for="email">Correu electrònic:</label>
        <input type="email" id="email" name="email" required>
    </div>

    <div>
        <label for="password">Contrasenya:</label>
        <input type="password" id="password" name="password" required minlength="8" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}">
    </div>

    <div>
        <label for="confirm_password">Repeteix la Contrasenya:</label>
        <input type="password" id="confirm_password" name="confirm_password" required minlength="8" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}">
    </div>

    <input type="submit" value="Registre">
</form>

<script>
    var password = document.getElementById("password");
    var confirm_password = document.getElementById("confirm_password");

    function validatePassword(){
        if(password.value != confirm_password.value) {
            confirm_password.setCustomValidity("Les contrasenyes no coincideixen");
        } else {
            confirm_password.setCustomValidity('');
        }
    }

    password.onchange = validatePassword;
    confirm_password.onkeyup = validatePassword;
</script>
</body>
</html>

