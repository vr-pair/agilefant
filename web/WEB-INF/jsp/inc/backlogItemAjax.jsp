<%@ include file="_taglibs.jsp"%>

<aef:hourReporting id="hourReport" />
<aef:currentUser />
<aef:userList />
<aef:teamList />
<aef:iterationGoalList id="iterationGoals" backlogId="${backlogId}" />
<aef:productList />

<div class="ajaxWindowTabsDiv">
<ul class="ajaxWindowTabs">
	<li><a href="#backlogItemEditTab-${backlogItemId}"><span><img src="static/img/edit.png" alt="Edit" /> Edit</span></a></li>
	<li><a href="#backlogItemProgressTab-${backlogItemId}"><span><img src="static/img/edit.png" alt="Progress" /> Progress</span></a></li>
	<li><a href="#backlogItemSpentEffTab-${backlogItemId}"><span><img src="static/img/timesheets.png" alt="Spent Effort" /> Spent Effort</span></a></li>
	<li><a href="#backlogItemThemesTab-${backlogItemId}"><span><img src="static/img/add_theme.png" alt="Themes" /> Themes</span></a></li>
</ul>

<div id="backlogItemEditTab-${backlogItemId}" class="backlogItemNaviTab">

<ww:actionerror />
<ww:actionmessage />

<h2>Edit backlog item</h2>

<table>
<tbody>
	<tr>
	<td>
	<div class="subItems" style="margin-top: 0px; width: 725px;">
	<div id="editBacklogItemForm">

	<ww:form action="ajaxStoreBacklogItem" method="post">
		<ww:hidden name="backlogItemId" value="${backlogItem.id}" />	
		<ww:hidden name="effortLeft" value="${backlogItem.effortLeft}" />
	
		<table class="formTable">		
			<tr>			
				<td>Name</td>												
				<td>*</td>
				<td colspan="2"><ww:textfield size="60" name="backlogItem.name" /></td>
			</tr>
			
			<tr>
				<td>Description</td>
				<td></td>
				<td colspan="2">
					<ww:textarea cols="70" rows="10" cssClass="useWysiwyg" id="backlogItemDescription" 
					name="backlogItem.description" value="${aef:nl2br(backlogItem.description)}" /></td>
			</tr>
			<c:choose>
				<c:when test="${backlogItem.originalEstimate == null}">
					<tr>
						<td>Original estimate</td>
						<td></td>
						<td colspan="2">
						<c:choose>
							<c:when test="${backlogItem.state.name != 'DONE'}">
								<ww:textfield size="10"
								name="backlogItem.originalEstimate"
								id="originalEstimateField" />
							</c:when>
							<c:otherwise>
								<ww:textfield size="10"
								name="backlogItem.originalEstimate"
								disabled="true"
								id="originalEstimateField" />
							</c:otherwise>
						</c:choose>
						<ww:label value="%{getText('webwork.estimateExample')}" /></td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<td>Original estimate</td>
						<td></td>
						<td colspan="2"><ww:label
							value="${backlogItem.originalEstimate}" /> <ww:hidden
							name="backlogItem.originalEstimate"
							value="${backlogItem.originalEstimate}" /> <ww:url id="resetLink"
							action="resetBliOrigEstAndEffortLeft" includeParams="none">
							<ww:param name="backlogItemId" value="${backlogItem.id}" />
						</ww:url>
						<c:choose>
							<c:when test="${backlogItem.state.name == 'DONE'}">
								<span id="resetText" style="color: #666;">(reset)</span>
								<span id="resetLink" style="display: none;">
							</c:when>
							<c:otherwise>
							<span id="resetText" style="color: #666; display: none;">(reset)</span>
								<span id="resetLink">
							</c:otherwise>
						</c:choose>
						
						<ww:a
								href="%{resetLink}&contextViewName=editBacklogItem&contextObjectId=${backlogItemId}"
								onclick="return confirmReset()">(reset)</ww:a>
						</span>
						
						
						</td>
					</tr>
					<tr>
						<td>Effort left</td>
						<td></td>
						<td colspan="2">
						<c:choose>
							<c:when test="${backlogItem.state.name != 'DONE'}">
								<ww:textfield size="10"
								name="backlogItem.effortLeft"
								id="effortLeftField" />
							</c:when>
							<c:otherwise>
								<ww:textfield size="10"
								name="backlogItem.effortLeft"
								disabled="true"
								id="effortLeftField" />
							</c:otherwise>
						</c:choose>
						<ww:label value="%{getText('webwork.estimateExample')}" />
						</td>
					</tr>
				</c:otherwise>
			</c:choose>
	
			<tr>
				<td>State</td>
				<td></td>
				<td colspan="2">
				<script type="text/javascript">
				function change_estimate_enabled(value) {
					var effLeftField = document.getElementById('effortLeftField');
					var origEstField = document.getElementById('originalEstimateField');
					var resetLink = document.getElementById('resetLink');
					var resetText = document.getElementById('resetText');
					if (value == 'DONE') {
						if (effLeftField != null) {
							effLeftField.disabled = true;
						}
						if (origEstField != null) {
							origEstField.disabled = true;
						}
						if (resetLink != null) {
							resetLink.style.display = "none";
						}
						if (resetText != null) {
							resetText.style.display = "";
						}
					}
					else {
						if (effLeftField != null) {
							effLeftField.disabled = false;
						}
						if (origEstField != null) {
							origEstField.disabled = false;
						}
						if (resetLink != null) {
							resetLink.style.display = "";
						}
						if (resetText != null) {
							resetText.style.display = "none";
						}
					}
				}
				</script>
				<%-- If user changed the item's state to DONE and there are tasks not DONE, ask if they should be set to DONE as well. --%>
				<script type="text/javascript">
				$(document).ready(function() {
					$("#stateSelect").change(function() {
						change_estimate_enabled($(this).val());				
						var tasksDone = true;
						$(".taskStateSelect").each(function() {
							if ($(this).val() != 'DONE') {
								tasksDone = false;
							}
						});
						if ($(this).val() == 'DONE' && !tasksDone) {
							var prompt = window.confirm("Do you wish to set all the tasks' states to Done as well?");
							if (prompt) {
								$(".taskStateSelect").val('DONE');
							}						
						}
					});
				});
				</script>
				<%-- Tasks to DONE confirmation script ends. --%>			
				<ww:select name="backlogItem.state"
					id="stateSelect"
					value="backlogItem.state.name"
					list="@fi.hut.soberit.agilefant.model.State@values()" listKey="name"
					listValue="getText('task.state.' + name())"  /></td>
			</tr>
	
			<tr>
				<td>Backlog</td>
				<td></td>
				<td colspan="2">
				<c:choose>
					<c:when test="${backlogItemId == 0}">
						<select name="backlogId" 
										onchange="disableIfEmpty(this.value, ['createButton', 'createAndCloseButton']);">
					</c:when>
					<c:otherwise>
						<select name="backlogId" onchange="disableIfEmpty(this.value, ['saveButton', 'saveAndCloseButton']);">
					</c:otherwise>
				</c:choose>
	
					<%-- Generate a drop-down list showing all backlogs in a hierarchical manner --%>
					<option class="inactive" value="">(select backlog)</option>
					<c:forEach items="${productList}" var="product">
						<c:choose>
							<c:when test="${product.id == currentPageId}">
								<option selected="selected" value="${product.id}" class="productOption"
									title="${product.name}">${aef:out(product.name)}</option>
							</c:when>
							<c:otherwise>
								<option value="${product.id}" title="${product.name}" class="productOption">${aef:out(product.name)}</option>
							</c:otherwise>
						</c:choose>
						<c:forEach items="${product.projects}" var="project">
							<c:choose>
								<c:when test="${project.id == currentPageId}">
									<option selected="selected" value="${project.id}" class="projectOption"
										title="${project.name}">${aef:out(project.name)}</option>
								</c:when>
								<c:otherwise>
									<option value="${project.id}" title="${project.name}"  class="projectOption">${aef:out(project.name)}</option>
								</c:otherwise>
							</c:choose>
							<c:forEach items="${project.iterations}" var="iteration">
								<c:choose>
									<c:when test="${iteration.id == currentPageId}">
										<option selected="selected" value="${iteration.id}" class="iterationOption"
											title="${iteration.name}">${aef:out(iteration.name)}</option>
									</c:when>
									<c:otherwise>
										<option value="${iteration.id}" title="${iteration.name}"  class="iterationOption">${aef:out(iteration.name)}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</c:forEach>
					</c:forEach>
				</select></td>
			</tr>
			<tr>
				<td>Iteration goal</td>
				<td></td>
				<%-- If iteration goals doesn't exist default value is 0--%>
				<td colspan="2"><c:choose>
					<c:when test="${!empty iterationGoals}">
						<c:set var="goalId" value="0" scope="page" />
						<c:if test="${iterationGoalId > 0}">
							<c:set var="goalId" value="${iterationGoalId}" />
						</c:if>
						<c:if test="${!empty backlogItem.iterationGoal}">
							<c:set var="goalId" value="${backlogItem.iterationGoal.id}"
								scope="page" />
						</c:if>
						<ww:select headerKey="0" headerValue="(none)"
							name="backlogItem.iterationGoal.id" list="#attr.iterationGoals"
							listKey="id" listValue="name" value="${goalId}" />
					</c:when>
					<c:otherwise>
						(none)
					</c:otherwise>
				</c:choose></td>
			</tr>
			<tr>
				<td>Priority</td>
				<td></td>
				<td colspan="2"><ww:select name="backlogItem.priority"
					value="backlogItem.priority.name"
					list="#@java.util.LinkedHashMap@{'UNDEFINED':'undefined', 'BLOCKER':'+++++', 'CRITICAL':'++++', 'MAJOR':'+++', 'MINOR':'++', 'TRIVIAL':'+'}" /></td>
				<%--
			If you change something about priorities, remember to update conf/classes/messages.properties as well!
			--%>
			</tr>
			
			<tr>
				<td>Responsibles</td>
				<td></td>
				<td colspan="2">
	
				<div id="assigneesLink">
				<a href="javascript:toggleDiv('userselect')" class="assignees">
				<img src="static/img/users.png"/>
				<c:set var="listSize" value="${fn:length(backlogItem.responsibles)}" scope="page" />
				<c:choose>
				<c:when test="${listSize > 0}">
					<c:set var="count" value="0" scope="page" />
					<c:set var="comma" value="," scope="page" />
					<c:forEach items="${backlogItem.responsibles}" var="responsible">
						<c:set var="unassigned" value="0" scope="page" />
						<c:if test="${count == listSize - 1}" >
							<c:set var="comma" value="" scope="page" />
						</c:if>
						<c:if test="${!empty backlogItem.project}" >
							<c:set var="unassigned" value="1" scope="page" />
							<c:forEach items="${backlogItem.project.responsibles}" var="projectResponsible">
								<c:if test="${responsible.id == projectResponsible.id}" >
									<c:set var="unassigned" value="0" scope="page" />
								</c:if>
							</c:forEach>
						</c:if>
						<c:choose>
							<c:when test="${unassigned == 1}">
								<span><c:out value="${responsible.initials}" /></span><c:out value="${comma}" />
							</c:when>
							<c:otherwise>
								<c:out value="${responsible.initials}" /><c:out value="${comma}" />
							</c:otherwise>
						</c:choose>
						<c:set var="count" value="${count + 1}" scope="page" />
					</c:forEach>
				</c:when>
				<c:otherwise>
					<c:out value="none" />
				</c:otherwise>
				</c:choose>
				</a>
				</div>
	
				<script type="text/javascript">
				$(document).ready( function() {
					<ww:set name="userList" value="${possibleResponsibles}" />
					<ww:set name="teamList" value="#attr.teamList" />
					<c:choose>
					<c:when test="${backlogItem.project != null}">
					var others = [<aef:userJson items="${aef:listSubstract(possibleResponsibles, backlogItem.project.responsibles)}"/>];
					var preferred = [<aef:userJson items="${backlogItem.project.responsibles}"/>];
					</c:when>
					<c:otherwise>
					var others = [<aef:userJson items="${possibleResponsibles}"/>];
					var preferred = [];
					</c:otherwise>
					</c:choose>
					
					var teams = [<aef:teamJson items="${teamList}"/>];
					var selected = [<aef:idJson items="${backlogItem.responsibles}"/>]
					$('#userselect').multiuserselect({users: [preferred,others], groups: teams, root: $('#userselect')}).selectusers(selected);								
					
				});
				</script>
				<div id="userselect" style="display: none;">
				<div class="left">
				<c:if test="${!aef:isProduct(backlog) &&
				             backlog != null}">
					<label>Users assigned to this project</label>
						<ul class="users_0"></ul>
					<label>Users not assigned this project</label>
				</c:if>
					<ul class="users_1"></ul>
				</div>
				<div class="right"><label>Teams</label>
				<ul class="groups" />
				</div>
				</div>
				</td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td><ww:submit value="Save" id="saveButton" /></td>
				<td class="deleteButton">
				<ww:submit value="Delete" onclick="return deleteBacklogItem(${backlogItemId})" />
				<ww:reset value="Cancel"
					onclick="closeTabs('backlogItems', 'backlogItemTabContainer-${backlogItemId}', ${backlogItemId});" />				
				</td>
			</tr>
		</table>
	
	</ww:form>

</div>
</div>

</td>
</tr>
</tbody>
</table>
	
</div>
<!-- edit tab ends -->

<!-- tasks tab begins -->
<div id="backlogItemProgressTab-${backlogItemId}" class="backlogItemNaviTab">

<h2>Progress</h2>

<script type="text/javascript">
	$(document).ready( function() {
	// Task ranking
		$('.moveUp').click(function() {
			var me = $(this);
			$.get(me.attr('href'), null, function() {me.moveup();});
			return false;
		});
		$('.moveDown').click(function() {
			var me = $(this);
			$.get(me.attr('href'), null, function() {me.movedown();});
			return false;
		});
		$('.moveTop').click(function() {
			var me = $(this);
			$.get(me.attr('href'), null, function() {me.movetop();});
			return false;
		});
		$('.moveBottom').click(function() {
			var me = $(this);
			$.get(me.attr('href'), null, function() {me.movebottom();});
			return false;
		});				
	});
</script>

<ww:form action="quickStoreTaskList" validate="false">

<table>
<tbody>
	<tr>
	<td>
	<div class="subItems" style="margin-top: 0px; width: 725px;">

	<table class="formTable">
	<tr>
	<td colspan="2">
	<table>
	<tbody>
		<tr>
			<td>
				Backlog item state
				<ww:select name="state"
					id="stateSelect_${backlogItem.id}" value="#attr.backlogItem.state.name"
					list="@fi.hut.soberit.agilefant.model.State@values()" listKey="name"
					listValue="getText('backlogItem.state.' + name())"/>
			</td>
			
			<td>
				Effort estimate			
				<ww:hidden name="backlogItemId" value="${backlogItem.id}" />
				<ww:hidden name="contextViewName" value="${contextViewName}" />
				<ww:hidden name="contextObjectId" value="${contextObjectId}" />
				<c:choose>
					<c:when test="${backlogItem.state.name != 'DONE'}">
						<ww:textfield size="5" name="effortLeft"
							value="${backlogItem.effortLeft}" id="effortBli_${backlogItem.id}" />	
					</c:when>
					<c:otherwise>
						<ww:textfield size="5" name="effortLeft"
							value="${backlogItem.effortLeft}" id="effortBli_${backlogItem.id}"
							disabled="true" />
					</c:otherwise>
				</c:choose>	
			</td>
			
			<td>
				<c:if test="${hourReport}">			
				Log effort for <c:out value="${currentUser.initials}"/> 		
		        <ww:url id="hourentryLink" action="createHourEntry" includeParams="none">
					<ww:param name="backlogItemId" value="${backlogItem.id}" />
					<ww:param name="iterationId" value="${iterationId}" />
					<ww:param name="autoclose" value="1" />
				</ww:url>			
				<ww:textfield size="5" name="spentEffort" id="effortSpent_${backlogItem.id}"/>  
				</c:if>
			</td>
	
	<script type="text/javascript">
	function change_effort_enabled(value, bliId) {
		if (value == "DONE") {
			document.getElementById("effortBli_" + bliId).disabled = true;							
		}
		else {
			document.getElementById("effortBli_" + bliId).disabled = false;
		}
	}
	</script>
	<%-- If user changed the item's state to DONE and there are tasks not DONE, ask if they should be set to DONE as well. --%>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#stateSelect_${backlogItem.id}").change(function() {
				change_effort_enabled($(this).val(), ${backlogItem.id});
				var tasksDone = true;
				$(".taskStateSelect_${backlogItem.id}").each(function() {
					if ($(this).val() != 'DONE') {
						tasksDone = false;
					}
				});
				if ($(this).val() == 'DONE' && !tasksDone) {
					var prompt = window.confirm("Do you wish to set all the tasks' states to Done as well?");
					if (prompt) {
						$(".taskStateSelect_${backlogItem.id}").val('DONE');
					}					
				}
			});
		});
	</script>
	<%-- Tasks to DONE confirmation script ends. --%>
	</td>
	</tr>
	</tbody>
	</table>
	
	</td>
	</tr>
	
	<tr>
	<td colspan="2">
	<!-- task table begins -->
	<table>
		<tr>
			<td>
				<div class="subItems" style="margin-top: 0px; width: 710px;">
				<div class="subItemHeader">			
				<table cellpadding="0" cellspacing="0">
	            	<tr>
	                <td class="header">Todos</td>
					</tr>
				</table>
				</div>
				<c:if test="${!empty backlogItem.tasks}">
					<div class="subItemContent">										
					<p>
					<display:table class="listTable" name="backlogItem.tasks"
						id="row" requestURI="editBacklogItem.action">
						
						<display:column sortable="false" title="Name"
							class="shortNameColumn">
							<ww:textfield size="20" name="taskNames[${row.id}]" value="${row.name}" />												
							<!-- ${aef:html(row.name)} -->					
						</display:column>
														
						<display:column sortable="false" title="State">											
							<ww:select cssClass="taskStateSelect_${backlogItem.id}"
								name="taskStates[${row.id}]" value="#attr.row.state.name"
								list="@fi.hut.soberit.agilefant.model.State@values()" listKey="name"
								listValue="getText('task.state.' + name())" id="taskStateSelect_${row.id}"/>														
						</display:column>
											
						<display:column sortable="false" title="Actions">
							<ww:url id="moveTaskTopLink" action="moveTaskTop" includeParams="none">
								<ww:param name="taskId" value="${row.id}" />
							</ww:url>
							<ww:a cssClass="moveTop" href="%{moveTaskTopLink}">
								<img src="static/img/arrow_top.png" alt="Send to top"
									title="Send to top" />
							</ww:a>
	
							<ww:url id="moveTaskUpLink" action="moveTaskUp" includeParams="none">
								<ww:param name="taskId" value="${row.id}" />
							</ww:url>
							<ww:a cssClass="moveUp" href="%{moveTaskUpLink}">
								<img src="static/img/arrow_up.png" alt="Move up" title="Move up" />
							</ww:a>
	
							<ww:url id="moveTaskDownLink" action="moveTaskDown" includeParams="none">
								<ww:param name="taskId" value="${row.id}" />
							</ww:url>
							<ww:a cssClass="moveDown" href="%{moveTaskDownLink}">
								<img src="static/img/arrow_down.png" alt="Move down"
									title="Move down" />
							</ww:a>
	
							<ww:url id="moveTaskBottomLink" action="moveTaskBottom" includeParams="none">
								<ww:param name="taskId" value="${row.id}" />
							</ww:url>
							<ww:a cssClass="moveBottom" href="%{moveTaskBottomLink}">
								<img src="static/img/arrow_bottom.png" alt="Send to bottom"
									title="Send to bottom" />
							</ww:a>
	
							<ww:url id="deleteLink" action="deleteTask" includeParams="none">
								<ww:param name="taskId" value="${row.id}" />
							</ww:url>
							<ww:a 
								href="%{deleteLink}&contextViewName=editBacklogItem&contextObjectId=${backlogItemId}"
								onclick="return confirmDeleteTask()">
								<img src="static/img/delete.png" alt="Delete" title="Delete" />
							</ww:a>
						</display:column>
	
					</display:table></p>				
					</div>
				</c:if> <%-- No tasks --%>
				</div>
			</td>
		</tr>
	</table>
	<!-- task table ends -->
	</td>
	</tr>
	
	<tr>
	<td>
		<ww:submit value="Save" action="quickStoreTaskList" onclick="return validateSpentEffortById('effortSpent_${backlogItem.id}','Invalid format for spent effort.'); return false;" />
	</td>
	<td class="deleteButton">
		<ww:reset value="Cancel"
			onclick="closeTabs('backlogItems', 'backlogItemTabContainer-${backlogItemId}', ${backlogItemId});" />				
	</td>
	</tr>
	
	</table>
			
	</div>
	</td>
	</tr>		
</tbody>
</table>

</ww:form>

</div>
<!-- Tasks tab ends -->

<div id="backlogItemSpentEffTab-${backlogItemId}" class="backlogItemNaviTab">
	This is bli spent effort.
</div>

<div id="backlogItemThemesTab-${backlogItemId}" class="backlogItemNaviTab">
	This is bli themes.
</div>

</div>