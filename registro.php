<?php
$servername = "localhost";
$username = "root";
$password = "";
$database = "nextsport";

// Conectar a la base de datos
$conn = new mysqli($servername, $username, $password, $database);

// Verificar la conexión
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id_registro = $_POST["id_registro"];
    $telefono = $_POST["telefono"];

    echo "id_registro: " . $id_registro . "<br>";
    echo "telefono: " . $telefono . "<br>";

    $sql = "INSERT INTO clientes (id_registro, telefono) VALUES (?, ?)";

    $stmt = $conn->prepare($sql);
    if ($stmt === false) {
        die("Error en la preparación de la consulta: " . $conn->error);
    }

    $stmt->bind_param("ss", $id_registro, $telefono);

    if ($stmt->execute()) {
        echo "Datos registrados con éxito.";
    } else {
        echo "Error al registrar los datos: " . $stmt->error;
    }

    $stmt->close();
}

$conn->close();
?>
