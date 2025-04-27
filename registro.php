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

// Verificar si los datos del formulario están presentes
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Validar que los campos no estén vacíos
    if (empty($_POST["id_registro"]) || empty($_POST["telefono"])) {
        die("Los campos id_registro y telefono son obligatorios.");
    }

    // Recibir datos del formulario
    $id_registro = $_POST["id_registro"];
    $telefono = $_POST["telefono"];

    // Insertar en la base de datos
    $sql = "INSERT INTO clientes (id_registro, telefono) 
            VALUES (?, ?)";

    // Preparar la consulta
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $id_registro, $telefono);  // 'ss' porque ambos son cadenas de texto (strings)

    // Ejecutar la consulta y verificar si fue exitosa
    if ($stmt->execute()) {
        echo "Datos registrados con éxito.";
    } else {
        echo "Error al registrar los datos: " . $stmt->error;
    }

    // Cerrar la sentencia
    $stmt->close();
} else {
    echo "Solicitud incorrecta.";
}

// Cerrar la conexión
$conn->close();
?>
