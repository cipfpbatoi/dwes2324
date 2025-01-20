<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulari de Login</title>
</head>
<body>
<form action="login.php" method="post">
    <div>
        <label for="email">Correu electrònic:</label>
        <input type="email" id="email" name="email" required>
    </div>
    <div>
        <label for="password">Contrasenya:</label>
        <input type="password" id="password" name="password" required>
    </div>
    <input type="submit" value="Login">
</form>
</body>
</html>
