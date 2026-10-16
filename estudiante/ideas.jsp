<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-estudiante.jspf" %>
<c:set var="titulo" value="Ideas de proyecto"/>

<sql:query var="mio" dataSource="${bd}">
    SELECT COUNT(*) AS n FROM anteproyectos WHERE id_estudiante = ?
    <sql:param value="${sessionScope.id_usuario}"/>
</sql:query>

<sql:query var="rs" dataSource="${bd}">
    SELECT id_idea, titulo, descripcion
    FROM ideas
    WHERE estado = 'Disponible'
    ORDER BY id_idea DESC
</sql:query>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<h1>Ideas de proyecto disponibles</h1>

<c:choose>
    <c:when test="${mio.rows[0].n > 0}">
        <div class="panel">
            <h3>Ya selecciono una idea</h3>
            <p class="subtitulo">Cada estudiante trabaja con una sola idea. Para cambiarla debe eliminar su anteproyecto actual.</p>
            <div class="acciones">
                <a class="btn btn-primario" href="${ctx}/estudiante/anteproyecto.jsp">Ir a mi anteproyecto</a>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <p class="subtitulo">Seleccione la idea con la que desea desarrollar su trabajo de grado.</p>
        <div class="rejilla-tarjetas">
            <c:forEach var="f" items="${rs.rows}">
                <div class="tarjeta">
                    <h3><c:out value="${f.titulo}"/></h3>
                    <p><c:out value="${f.descripcion}"/></p>
                    <form action="${ctx}/estudiante/procesar-seleccionar-idea.jsp" method="post">
                        <input type="hidden" name="id_idea" value="${f.id_idea}">
                        <div class="acciones">
                            <button type="submit" class="btn btn-primario btn-sm">Seleccionar esta idea</button>
                        </div>
                    </form>
                </div>
            </c:forEach>
        </div>
        <c:if test="${rs.rowCount == 0}">
            <p class="vacio">No hay ideas disponibles por ahora. Consulte con coordinacion.</p>
        </c:if>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>