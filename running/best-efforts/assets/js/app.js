String.prototype.toHHMMSS = function() {
  var sec_num = parseInt(this, 10); // Don't forget the second param.
  var hours = Math.floor(sec_num / 3600);
  var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
  var seconds = sec_num - (hours * 3600) - (minutes * 60);

  if (hours < 10) {
    hours = "0" + hours;
  }
  if (minutes < 10) {
    minutes = "0" + minutes;
  }
  if (seconds < 10) {
    seconds = "0" + seconds;
  }

  var time = hours + ':' + minutes + ':' + seconds;
  return time;
}

function loadDistanceView(sidebarAnchor) {
  var distanceText = sidebarAnchor.attr("data-distance-text");
  var distanceName = sidebarAnchor.attr("data-distance-name");
  prepareDistanceView(distanceText, sidebarAnchor);
  createBestEffortTable([distanceName], Number.MAX_VALUE, false);
}

function prepareDistanceView(distanceText, sidebarAnchor) {
  // Update sidebar treeview to make only this anchor active.
  $("a[id^='best-effort-']").each(function() {
    $(this).parent().removeClass("active");
    $(this).children("i").removeClass("fa-check-circle-o");
    $(this).children("i").addClass("fa-circle-o");
  });
  sidebarAnchor.parent().addClass("active");
  sidebarAnchor.children("i").removeClass("fa-circle-o");
  sidebarAnchor.children("i").addClass("fa-check-circle-o");

  // Update content header and breadcrumb.
  var transitionTime = 100;
  $(".content-header h1").text("Best Efforts for " + distanceText);
  $(".content-header .breadcrumb li.active").fadeOut(transitionTime, function() {
    $(this).text(distanceText).fadeIn(transitionTime);
  });

  // Update page title.
  $(document).prop("title", "Strava Best Efforts | " + distanceText);

  // Empty main content.
  $('#main-content').empty();
}

function loadOverview() {
  var distancesToShow = ['Marathon', 'Half-Marathon', '10k', '5k', '1 mile', '1k'];
  var limitPerDistance = 3;
  createBestEffortTable(distancesToShow, limitPerDistance, true);
}

function createBestEffortTable(distancesToShow, totalItems, isOverview) {
  var allDistances = ['50k', 'Marathon', '30k', 'Half-Marathon', '20k', '10 mile', '15k', '10k', '5k', '2 mile', '1 mile', '1k', '1/2 mile', '400m'];

  // Retrieve and parse data from JSON file.
  $.getJSON('./data.json').then(function(data) {
    var bestEffortsJsonData = [];
    $.each(data, function(key, value) {
      bestEffortsJsonData.push(value);
    });

    allDistances.forEach(function(distance) {
      var bestEffortsForThisDistance = [];
      bestEffortsJsonData.forEach(function(bestEffort) {
        if (bestEffort['name'] === distance && bestEffort['pr_rank'] === 1) {
          bestEffortsForThisDistance.push(bestEffort);
        }
      });

      // Append the count of best efforts for this distance to treeview links.
      var distanceId = distance.toLowerCase().replace(/ /g, '-').replace(/\//g, '-');
      var countLabel = "#best-effort-" + distanceId + " small";
      $(countLabel).remove();
      var countLabelHtml = "<span class='pull-right-container'><small class='pull-right'>" + bestEffortsForThisDistance.length + "</small></span>"
      $("#best-effort-" + distanceId).append(countLabelHtml);

      // If this distance contains best efforts activities,
      // and it's one of those distances to be shown on overview page,
      // create the best efforts table for this distance.
      if (bestEffortsForThisDistance.length > 0 && distancesToShow.indexOf(distance) !== -1) {
        var table = constructBestEffortTableHtml(distance, bestEffortsForThisDistance, totalItems, isOverview);
        $('#main-content').append(table).fadeIn(1000);
      }
    });
  }).done(function() {
      $(".best-effort-table.datatable").each(function() {
        $(this).DataTable({
          "iDisplayLength": 10,
          "order": [[0, "desc"]]
        });
      });
  });
}

function constructBestEffortTableHtml(distance, bestEfforts, totalItems, isOverview) {
  var distanceName = distance.replace(/-/g, ' ');

  var table = "<div class='row'><div class='col-xs-12'><div class='box'>"
  if (isOverview) {
    table += "<div class='box-header'><h3 class='box-title'>" + distanceName + "</h3></div>";
  }
  table += "<div class='box-body'>";
  table += "<table class='best-effort-table " + (isOverview ? " " : "datatable ") + "table table-bordered table-striped'>";
  table += "<thead><tr>"
  table += "<th class='col-md-1'>Date</th>"
  table += "<th class='col-md-1 text-center badge-cell'>Type</th>"
  table += "<th class='col-md-4'>Activity</th>"
  table += "<th class='col-md-1'>Time</th>"
  table += "<th class='col-md-2'>Shoes</th>"
  table += "<th class='col-md-1 text-center badge-cell'>Avg. HR</th>"
  table += "<th class='col-md-1 text-center badge-cell'>Max HR</th>"
  table += "</tr></thead>";
  table += "<tbody>";

  // Take only the fastest three for Overview page.
  bestEfforts.reverse().slice(0, totalItems).forEach(function(bestEffort) {
    table += "<tr>";
    table += "<td>" + bestEffort["start_date"].slice(0, 10); + "</td>";
    table += "<td class='text-center badge-cell'>" + createWorkoutTypeBadge(bestEffort["workout_type"]) + "</td>";
    table += "<td>"
      + "<a href='https://www.strava.com/activities/"
      + bestEffort['activity_id']
      + "' target='_blank'>"
      + bestEffort['activity_name']
      + "</a>"
      + "</td>";
    table += "<td>" + bestEffort['elapsed_time'].toString().toHHMMSS() + "</td>";

    var gearName = '-';
    if (bestEffort['gear_name']) {
      gearName = bestEffort['gear_name'];
    }
    table += "<td>" + gearName + "</td>";

    table += "<td class='text-center badge-cell'>";
    var averageHeartRate = Math.round(bestEffort['average_heartrate']);
    table += createHeartRateBadge(averageHeartRate);
    table += "</td>";

    table += "<td class='text-center badge-cell'>";
    var maxHeartRate = Math.round(bestEffort['max_heartrate']);
    table += createHeartRateBadge(maxHeartRate);
    table += "</td>";

    table += "</tr>";
  });

  table += "</tbody>";
  table += "</table>";
  table += "</div></div></div></div>";
  return table;
}

function createWorkoutTypeBadge(workoutType) {
  var badgeColor = "green";
  var workoutTypeName = "Run";
  if (workoutType === 1) {
    badgeColor = "red";
    workoutTypeName = "Race";
  }
  if (workoutType === 2) {
    badgeColor = "olive";
    workoutTypeName = "Long Run";
  }
  if (workoutType === 3) {
    badgeColor = "yellow";
    workoutTypeName = "Workout";
  }
  return "<span class='label bg-" + badgeColor + "'>" + workoutTypeName + "</span>";
}

function createHeartRateBadge(heartRate) {
  var badgeColor = "grey";
  if (heartRate === 0) {
    heartRate = "n/a";
  }
  if (heartRate < 163) {
    badgeColor = "green";
  }
  if (heartRate > 163 && heartRate <= 169) {
    badgeColor = "yellow";
  }
  else if (heartRate > 169 && heartRate <= 176) {
    badgeColor = "orange";
  }
  else if (heartRate > 176 && heartRate <= 182) {
    badgeColor = "red";
  }
  else if (heartRate > 182 && heartRate <= 189) {
    badgeColor = "purple";
  }
  else if (heartRate > 189) {
    badgeColor = "black";
  }
  return "<span class='badge bg-" + badgeColor + "'>" + heartRate + "</span>";
}
