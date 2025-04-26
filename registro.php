<?php
$servername = "localhost";
$username = "root"; // Usuario de MySQL
$password = ""; // Contraseña de MySQL (déjalo vacío si no usaste una)
$database = "NextSport";

// Conectar a MySQL
$conn = new mysqli($servername, $username, $password, $database);

// Verificar conexión
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

// Recibir datos del formulario
$usuario = $_POST["usuario"];
$nombre = $_POST["nombre"];
$apellido = $_POST["apellido"];
$correo = $_POST["correo"];
$telefono = $_POST["telefono"];
$contrasena = password_hash($_POST["contrasena"], PASSWORD_DEFAULT); // Encriptar contraseña
$estado = "activo"; // Por defecto, los nuevos usuarios estarán activos

// Insertar en la base de datos
$sql = "INSERT INTO clientes (usuario, nombre, apellido, correo, telefono, contrasena, estado) 
        VALUES (?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param("sssssss", $usuario, $nombre, $apellido, $correo, $telefono, $contrasena, $estado);

if ($stmt->execute()) {
    echo "Usuario registrado con éxito.";
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>
