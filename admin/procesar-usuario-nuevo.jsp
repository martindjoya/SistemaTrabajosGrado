<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-admin.jspf" %>

<c:if test="${pageContext.request.method != 'POST'}">
    <c:redirect url="/admin/usuarios.jsp"/>
</c:if>

<%-- ===== FORMATOS (REGEXP) ===== --%>
<sql:query var="v" dataSource="${bd}">
    SELECT (? REGEXP '^[0-9]{5,20}$') AS doc_ok,
           (? = '' OR ? REGEXP '^[0-9]{7,15}$') AS tel_ok,
           (? REGEXP '^[^@ ]+@[^@ ]+[.][^@ ]+$') AS cor_ok,
           (? REGEXP '^[A-Za-z0-9_.]{4,30}$') AS usu_ok
    <sql:param value="${fn:trim(param.documento)}"/>
    <sql:param value="${fn:trim(param.telefono)}"/>
    <sql:param value="${fn:trim(param.telefono)}"/>
    <sql:param value="${fn:trim(param.correo)}"/>
    <sql:param value="${fn:trim(param.usuario)}"/>
</sql:query>
<c:set var="f" value="${v.rows[0]}"/>

<%-- ===== VALIDACIONES ===== --%>
<c:set var="msg" value=""/>
<c:choose>
    <c:when test="${empty fn:trim(param.nombres) or empty fn:trim(param.apellidos) or empty fn:trim(param.documento) or empty fn:trim(param.correo) or empty fn:trim(param.usuario) or empty param.contrasena or empty param.id_rol}">
        <c:set var="msg" value="Complete todos los campos obligatorios."/>
    </c:when>
    <c:when test="${f.doc_ok != 1}">
        <c:set var="msg" value="El documento debe tener solo numeros (5 a 20 digitos)."/>
    </c:when>
    <c:when test="${f.tel_ok != 1}">
        <c:set var="msg" value="El telefono debe tener solo numeros (7 a 15 digitos)."/>
    </c:when>
    <c:when test="${f.cor_ok != 1}">
        <c:set var="msg" value="El correo electronico no es valido."/>
    </c:when>
    <c:when test="${f.usu_ok != 1}">
        <c:set var="msg" value="El usuario debe tener de 4 a 30 caracteres (letras o numeros o punto o guion bajo)."/>
    </c:when>
    <c:when test="${fn:length(param.contrasena) lt 6}">
        <c:set var="msg" value="La contrasena debe tener minimo 6 caracteres."/>
    </c:when>
    <c:when test="${param.id_rol lt 2 or param.id_rol gt 5}">
        <c:set var="msg" value="Seleccione un rol valido."/>
    </c:when>
    <c:when test="${param.id_rol == 5 and (empty fn:trim(param.codigo) or empty fn:trim(param.programa))}">
        <c:set var="msg" value="Para un estudiante el codigo y el programa son obligatorios."/>
    </c:when>
    <c:when test="${(param.id_rol == 3 or param.id_rol == 4) and empty fn:trim(param.especialidad)}">
        <c:set var="msg" value="Para un director o evaluador la especialidad es obligatoria."/>
    </c:when>
</c:choose>

<%-- ===== DUPLICADOS ===== --%>
<c:if test="${empty msg}">
    <sql:query var="dup" dataSource="${bd}">
        SELECT COALESCE(SUM(documento = ?), 0) AS n_doc,
               COALESCE(SUM(correo = ?), 0) AS n_cor,
               COALESCE(SUM(usuario = ?), 0) AS n_usu
        FROM usuarios
        WHERE documento = ? OR correo = ? OR usuario = ?
        <sql:param value="${fn:trim(param.documento)}"/>
        <sql:param value="${fn:trim(param.correo)}"/>
        <sql:param value="${fn:trim(param.usuario)}"/>
        <sql:param value="${fn:trim(param.documento)}"/>
        <sql:param value="${fn:trim(param.correo)}"/>
        <sql:param value="${fn:trim(param.usuario)}"/>
    </sql:query>
    <c:choose>
        <c:when test="${dup.rows[0].n_doc > 0}"><c:set var="msg" value="Ya existe un usuario con ese documento."/></c:when>
        <c:when test="${dup.rows[0].n_cor > 0}"><c:set var="msg" value="Ya existe un usuario con ese correo."/></c:when>
        <c:when test="${dup.rows[0].n_usu > 0}"><c:set var="msg" value="Ese nombre de usuario ya esta en uso."/></c:when>
    </c:choose>
</c:if>

<c:if test="${empty msg and param.id_rol == 5}">
    <sql:query var="dc" dataSource="${bd}">
        SELECT COUNT(*) AS n FROM estudiantes WHERE codigo = ?
        <sql:param value="${fn:trim(param.codigo)}"/>
    </sql:query>
    <c:if test="${dc.rows[0].n > 0}">
        <c:set var="msg" value="Ya existe un estudiante con ese codigo."/>
    </c:if>
</c:if>

<c:if test="${not empty msg}">
    <jsp:forward page="/admin/usuario-nuevo.jsp">
        <jsp:param name="error" value="${msg}"/>
    </jsp:forward>
</c:if>

<%-- ===== GUARDAR (TRANSACCION) ===== --%>
<c:catch var="err">
    <sql:transaction dataSource="${bd}">
        <sql:update>
            INSERT INTO usuarios (nombres, apellidos, documento, correo, telefono, usuario, contrasena, id_rol)
            VALUES (?, ?, ?, ?, ?, ?, SHA2(?, 256), ?)
            <sql:param value="${fn:trim(param.nombres)}"/>
            <sql:param value="${fn:trim(param.apellidos)}"/>
            <sql:param value="${fn:trim(param.documento)}"/>
            <sql:param value="${fn:trim(param.correo)}"/>
            <sql:param value="${fn:trim(param.telefono)}"/>
            <sql:param value="${fn:trim(param.usuario)}"/>
            <sql:param value="${param.contrasena}"/>
            <sql:param value="${param.id_rol}"/>
        </sql:update>

        <c:if test="${param.id_rol == 5}">
            <sql:update>
                INSERT INTO estudiantes (id_usuario, codigo, programa)
                SELECT id_usuario, ?, ? FROM usuarios WHERE documento = ?
                <sql:param value="${fn:trim(param.codigo)}"/>
                <sql:param value="${fn:trim(param.programa)}"/>
                <sql:param value="${fn:trim(param.documento)}"/>
            </sql:update>
        </c:if>

        <c:if test="${param.id_rol == 3 or param.id_rol == 4}">
            <sql:update>
                INSERT INTO docentes (id_usuario, especialidad)
                SELECT id_usuario, ? FROM usuarios WHERE documento = ?
                <sql:param value="${fn:trim(param.especialidad)}"/>
                <sql:param value="${fn:trim(param.documento)}"/>
            </sql:update>
        </c:if>
    </sql:transaction>
</c:catch>

<c:if test="${not empty err}">
    <jsp:forward page="/admin/usuario-nuevo.jsp">
        <jsp:param name="error" value="No se pudo registrar el usuario. Intente de nuevo."/>
    </jsp:forward>
</c:if>

<c:redirect url="/admin/usuarios.jsp">
    <c:param name="ok" value="Usuario registrado correctamente."/>
</c:redirect>