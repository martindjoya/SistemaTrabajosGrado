<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>
<jsp:useBean id="ahora" class="java.util.Date"/>

<c:if test="${pageContext.request.method != 'POST'}">
    <c:redirect url="/estudiante/anteproyecto.jsp"/>
</c:if>

<%-- Leer el archivo (si supera el limite de tamano se produce una excepcion) --%>
<c:catch var="errArchivo">
    <c:set var="parte" value="${pageContext.request.getPart('archivo')}"/>
</c:catch>
<c:if test="${not empty errArchivo}">
    <c:redirect url="/estudiante/anteproyecto-subir.jsp">
        <c:param name="error" value="El archivo es demasiado grande. Maximo 5 MB."/>
    </c:redirect>
</c:if>

<%-- Anteproyecto del estudiante --%>
<sql:query var="rs" dataSource="${bd}">
    SELECT id_anteproyecto, estado FROM anteproyectos WHERE id_estudiante = ?
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>
<c:if test="${rs.rowCount == 0 or rs.rows[0].estado != 'Idea'}">
    <c:redirect url="/estudiante/anteproyecto.jsp">
        <c:param name="error" value="No es posible subir el anteproyecto en este momento."/>
    </c:redirect>
</c:if>
<c:set var="a" value="${rs.rows[0]}"/>

<%-- Tipo de archivo --%>
<c:set var="hayArchivo" value="${not empty parte and parte.size > 0}"/>
<c:set var="ext" value=""/>
<c:if test="${hayArchivo}">
    <c:set var="nombreOrig" value="${fn:toLowerCase(parte.submittedFileName)}"/>
    <c:choose>
        <c:when test="${fn:endsWith(nombreOrig, '.pdf')}"><c:set var="ext" value="pdf"/></c:when>
        <c:when test="${fn:endsWith(nombreOrig, '.docx')}"><c:set var="ext" value="docx"/></c:when>
        <c:when test="${fn:endsWith(nombreOrig, '.doc')}"><c:set var="ext" value="doc"/></c:when>
    </c:choose>
</c:if>

<%-- ===== VALIDACIONES ===== --%>
<c:set var="msg" value=""/>
<c:choose>
    <c:when test="${empty fn:trim(param.titulo) or empty fn:trim(param.resumen)}">
        <c:set var="msg" value="Complete todos los campos obligatorios."/>
    </c:when>
    <c:when test="${fn:length(fn:trim(param.titulo)) lt 5 or fn:length(fn:trim(param.titulo)) gt 150}">
        <c:set var="msg" value="El titulo debe tener entre 5 y 150 caracteres."/>
    </c:when>
    <c:when test="${fn:length(fn:trim(param.resumen)) lt 20}">
        <c:set var="msg" value="El resumen debe tener minimo 20 caracteres."/>
    </c:when>
    <c:when test="${not hayArchivo}">
        <c:set var="msg" value="Seleccione el documento del anteproyecto."/>
    </c:when>
    <c:when test="${empty ext}">
        <c:set var="msg" value="El documento debe ser PDF o Word (.pdf .doc .docx)."/>
    </c:when>
    <c:when test="${parte.size gt 5242880}">
        <c:set var="msg" value="El archivo es demasiado grande. Maximo 5 MB."/>
    </c:when>
</c:choose>

<c:if test="${not empty msg}">
    <jsp:forward page="/estudiante/anteproyecto-subir.jsp">
        <jsp:param name="error" value="${msg}"/>
    </jsp:forward>
</c:if>

<%-- ===== GUARDAR ARCHIVO ===== --%>
<c:set var="nombreArchivo" value="ante_${sessionScope.id_usuario}_${ahora.time}.${ext}"/>
<c:set var="carpeta" value="${pageContext.servletContext.getRealPath('/uploads')}"/>
<c:catch var="errFile">
    <c:set var="r" value="${parte.write(carpeta.concat('/').concat(nombreArchivo))}"/>
</c:catch>
<c:if test="${not empty errFile}">
    <jsp:forward page="/estudiante/anteproyecto-subir.jsp">
        <jsp:param name="error" value="No se pudo guardar el archivo. Verifique que exista la carpeta uploads."/>
    </jsp:forward>
</c:if>

<%-- ===== GUARDAR EN BASE DE DATOS ===== --%>
<c:catch var="err">
    <sql:update dataSource="${bd}">
        UPDATE anteproyectos
        SET titulo = ?, resumen = ?, archivo = ?, estado = 'Enviado', fecha_envio = NOW()
        WHERE id_anteproyecto = ? AND id_estudiante = ?
        <sql:param value="${fn:trim(param.titulo)}"/>
        <sql:param value="${fn:trim(param.resumen)}"/>
        <sql:param value="${nombreArchivo}"/>
        <sql:param value="${a.id_anteproyecto}"/>
        <sql:param value="${sessionScope.id_usuario}"/>
    </sql:update>
</c:catch>

<c:if test="${not empty err}">
    <jsp:forward page="/estudiante/anteproyecto-subir.jsp">
        <jsp:param name="error" value="No se pudo registrar el anteproyecto. Intente de nuevo."/>
    </jsp:forward>
</c:if>

<c:redirect url="/estudiante/anteproyecto.jsp">
    <c:param name="ok" value="Anteproyecto enviado correctamente."/>
</c:redirect>