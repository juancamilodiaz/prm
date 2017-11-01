<thead id="availabilityTableHead">
	<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-3">Resource Name</th>
	<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-1">Monday</th>
	<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-1">Tuesday</th>
	<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-1">Wednesday</th>
	<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-1">Thursday</th>
	<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-1">Friday</th>
</thead>
<tbody id="unassignBody">
	{{$availBreakdown := .AvailBreakdown}}
	{{$dates := .Dates}}
	{{range $index, $resource := .Resources}}
	<tr draggable=false>
		{{range $rID, $mapAvail := $availBreakdown}}
			{{if eq $resource.ID $rID}}
				<td style="background-position-x: 1%;font-size:11px;text-align: -webkit-center;margin:0 0 0px;">{{$resource.Name}} {{$resource.LastName}}</td>
				{{range $index, $date := $dates}}
					{{$availDay := index $mapAvail $date}}
					{{if $availDay}}
						<td style="font-size:11px;text-align: -webkit-center;">{{$availDay}}</td>
					{{else}}
						<td style="font-size:11px;text-align: -webkit-center;"></td>
					{{end}}
				{{end}}
			{{end}}
		{{end}}
	</tr>
	{{end}}
</tbody>