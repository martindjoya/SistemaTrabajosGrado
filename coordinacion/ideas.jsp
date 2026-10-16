<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/validar-coordinacion.jspf" %>
<c:set var="titulo" value="Ideas de anteproyecto"/>

<sql:query var="rs" dataSource="${bd}">
    SELECT id_idea, titulo, descripcion, estado, fecha_creacion
    FROM ideas
    WHERE (titulo LIKE ? OR descripcion LIKE ?)
      AND (? = '' OR estado = ?)
    ORDER BY id_idea DESC
    <sql:param value="%${param.q}%"/>
    <sql:param value="%${param.q}%"/>
    <sql:param value="${empty param.estado ? '' : param.estado}"/>
    <sql:param value="${empty param.estado ? '' : param.estado}"/>
</sql:query>

<%@ include file="/WEB-INF/jspf/encabezado.jspf" %>

<div class="barra-superior">
    <h1>Ideas de anteproyecto</h1>
    <a class="btn btn-primario" href="${ctx}/coordinacion/idea-nueva.jsp">Nueva idea</a>
</div>

<form class="buscador" action="${ctx}/coordinacion/ideas.jsp" method="get">
    <input type="text" name="q" placeholder="Buscar por titulo o descripcion" value="${fn:escapeXml(param.q)}">
    <select name="estado">
        <option value="">Todos los estados</option>
        <option value="Disponible" ${param.estado == 'Disponible' ? 'selected' : ''}>Disponible</option>
        <option value="Ocupada" ${param.estado == 'Ocupada' ? 'selected' : ''}>Ocupada</option>
    </select>
    <button type="submit" class="btn btn-secundario">Buscar</button>
</form>

<p class="subtitulo"><c:out value="${rs.rowCount}"/> idea(s) encontrada(s)</p>

<div class="tabla-wrap">
    <table>
        <thead>
            <tr>
                <th>Titulo</th>
                <th>Descripcion</th>
                <th>Estado</th>
                <th>Creada</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="f" items="${rs.rows}">
                <tr>
                    <td><c:out value="${f.titulo}"/></td>
                    <td>
                        <c:out value="${fn:substring(f.descripcion, 0, 90)}"/><c:if test="${fn:length(f.descripcion) > 90}">...</c:if>
                    </td>
                    <td>
                        <span class="badge ${f.estado == 'Disponible' ? 'badge-activo' : 'badge-enviado'}">
                            <c:out value="${f.estado}"/>
                        </span>
                    </td>
                    <td><fmt:formatDate value="${f.fecha_creacion}" pattern="dd/MM/yyyy"/></td>
                    <td>
                        <div class="acciones-tabla">
                            <a class="btn btn-secundario btn-sm" href="${ctx}/coordinacion/idea-editar.jsp?id=${f.id_idea}">Editar</a>
                            <a class="btn btn-peligro btn-sm" href="${ctx}/coordinacion/idea-eliminar.jsp?id=${f.id_idea}">Eliminar</a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${rs.rowCount == 0}">
                <tr><td colspan="5" class="vacio">No se encontraron ideas.</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>