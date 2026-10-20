<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<c:if test="${not empty sessionScope.id_usuario}">
    <%@ include file="/WEB-INF/jspf/redirigir-rol.jspf" %>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <title>Iniciar sesion | UTS</title>
    <link rel="stylesheet" href="${ctx}/css/estilos.css">
    <link rel="stylesheet" href="${ctx}/css/formularios.css">
    <link rel="stylesheet" href="${ctx}/css/login.css">
</head>
<body class="login-pagina">
    <div class="login-caja">
        <div class="login-marca">UTS</div>
        <h1>Iniciar sesion</h1>

        <%@ include file="/WEB-INF/jspf/mensajes.jspf" %>

        <form action="${ctx}/procesar-login.jsp" method="post">
            <div class="campo">
                <label for="usuario">Usuario</label>
                <input type="text" id="usuario" name="usuario" maxlength="30" required autofocus>
            </div>
            <div class="campo">
                <label for="contrasena">Contrasena</label>
                <input type="password" id="contrasena" name="contrasena" maxlength="50" required>
            </div>
            <button type="submit" class="btn btn-primario">Ingresar</button>
        </form>

        <p class="ayuda" style="text-align:center; margin-top:1rem;">
            Las cuentas son creadas unicamente por el administrador. Si no tiene una, solicitela en coordinacion.
        </p>

        <a class="volver" href="${ctx}/index.jsp">Volver al inicio</a>
    </div>
</body>
</html>
