function loadDistanceView(sidebarAnchor) {

  // Set the global configs to synchronous.
  $.ajaxSetup({
      async: false
  });

  var distanceText = sidebarAnchor.attr("data-distance-text");
  var distanceName = sidebarAnchor.attr("data-distance-name");
  prepareDistanceView(distanceText, sidebarAnchor);
  createMainContent([distanceName], Number.MAX_VALUE, false);

  // Add a warning message when there is no content.
  if ($('#main-content').is(':empty')) {
    var message = "<div class='alert alert-info col-md-8 col-md-offset-2'>"
      + "<h4><i class='icon fa fa-info'></i> Nothing here. Get out and run!</h4>";
    $('#main-content').append(message);
  } else {
    $(".best-effort-table.datatable").each(function() {
      $(this).DataTable({
        "columnDefs": [{
            "targets": [1, 3, 5, 6], // Disable searching for WorkoutType, Time and HRs.
            "searchable": false
          }],
        "iDisplayLength": 10,
        "order": [
          [0, "desc"]
        ]
      });
    });
  }

  // Set JS back to asynchronous mode.
  $.ajaxSetup({
      async: true
  });
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
  var headerText = "Best Efforts for " + distanceText;
  $(".content-header h1").text(headerText);
  $(".content-header .breadcrumb li.active").fadeOut(transitionTime, function() {
    $(this).text(headerText).fadeIn(transitionTime);
  });

  // Update page title.
  $(document).prop("title", "Strava Best Efforts | " + distanceText);

  // Empty main content.
  $('#main-content').empty();
}

function loadOverview() {
  var distancesToShow = ['Marathon', 'Half-Marathon', '10k', '5k', '1 mile', '1k'];
  var limitPerDistance = 3;
  createAthleteInfo();
  createMainContent(distancesToShow, limitPerDistance, true);
}

function createAthleteInfo() {
  $.getJSON('./athlete.json').then(function(data) {
    // There should only be one record of athlete data.
    // Get the first one regardless.
    var allAthleteInfo = [];
    $.each(data, function(key, value) {
      allAthleteInfo.push(value);
    });
    var athleteInfo = allAthleteInfo[0];

    // Athlete URL.
    var athleteUrl = "https://www.strava.com/athletes/" + athleteInfo['id'];
    $('.athlete-link').attr('href', athleteUrl);

    // Athlete Name.
    var name = athleteInfo['firstname'] + " " + athleteInfo['lastname'];
    $('.athlete-name').text(name);

    // Athlete Location.
    var location = athleteInfo['city'] + ", " + athleteInfo['country'];
    $('.athlete-location').text(location);

    // Athlete Profile Picture.
    $('.athlete-image').attr('src', athleteInfo['profile']);

    // Following.
    var friend_count = athleteInfo['friend_count'];
    var followingUrl = athleteUrl + "/follows?type=following";
    $('.athlete-following').attr('href', followingUrl);
    $('.athlete-following').text(friend_count);

    // Followers.
    var follower_count = athleteInfo['follower_count'];
    var followerUrl = athleteUrl + "/follows?type=followers";
    $('.athlete-follower').attr('href', followerUrl);
    $('.athlete-follower').text(follower_count);
  });
}

function createMainContent(distancesToShow, maxItemsAllowed, isOverview) {
  var allDistances = ['50k', 'Marathon', '30k', 'Half-Marathon', '20k', '10 mile', '15k', '10k', '5k', '2 mile',
    '1 mile', '1k', '1/2 mile', '400m'
  ];

  // Retrieve and parse data from JSON file.
  $.getJSON('./best-efforts.json').then(function(data) {
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
      var countLabelHtml = "<span class='pull-right-container'><small class='pull-right'>" +
        bestEffortsForThisDistance.length + "</small></span>"
      $("#best-effort-" + distanceId).append(countLabelHtml);

      // If this distance contains best efforts activities,
      // and it's one of those distances to be shown on overview page,
      // create the best efforts table for this distance.
      if (bestEffortsForThisDistance.length > 0 && distancesToShow.indexOf(distance) !== -1) {
        if (!isOverview) {
          var progressionChart = constructProgressionChartHtml();
          $('#main-content').append(progressionChart);
          createProgressionChart(distance, bestEffortsForThisDistance);
        }

        var table = constructBestEffortTableHtml(distance, bestEffortsForThisDistance, maxItemsAllowed, isOverview);
        $('#main-content').append(table);

        if (!isOverview) {
          var pieCharts = constructPieChartsHtml();
          $('#main-content').append(pieCharts);
          createWorkoutTypeChart(distance, bestEffortsForThisDistance);
          createGearChart(distance, bestEffortsForThisDistance);
        }
      }
    });
  });
}

function constructPieChartsHtml() {
  var chart = "<div class='row'>"

  chart += "<div class='col-md-6'>"
  chart += "<div class='box'>"
  chart += "<div class='box-header with-border>"
  chart += "<i class='fa fa-bar-chart-o'></i><h3 class='box-title'>Workout Type Chart</h3>";
  chart += "<div class='box-body'>";
  chart += "<div class='chart'>";
  chart += "<canvas id='workout-type-chart'></canvas>";
  chart += "</div></div></div></div></div>"

  chart += "<div class='col-md-6'>"
  chart += "<div class='box'>"
  chart += "<div class='box-header with-border>"
  chart += "<i class='fa fa-bar-chart-o'></i><h3 class='box-title'>Gear Chart</h3>";
  chart += "<div class='box-body'>";
  chart += "<div class='chart'>";
  chart += "<canvas id='gear-chart'></canvas>";
  chart += "</div></div></div></div></div>"

  chart += "</div>";
  return chart;
}

function constructProgressionChartHtml() {
  var chart = "<div class='row'><div class='col-xs-12'>"
  chart += "<div class='box'>"
  chart += "<div class='box-header with-border>"
  chart += "<i class='fa fa-bar-chart-o'></i><h3 class='box-title'>Progression Chart</h3>";
  chart += "<div class='box-body'>";
  chart += "<div class='chart'>";
  chart += "<canvas id='progression-chart'></canvas>";
  chart += "</div></div></div></div></div>";
  return chart;
}

function createProgressionChart(distance, bestEfforts) {
  var distanceName = distance.replace(/-/g, ' ');
  var dates = [];
  var runTimes = [];
  var runTimeLabels = [];

  bestEfforts.forEach(function(bestEffort) {
    var date = bestEffort["start_date"].slice(0, 10);
    var runTime = bestEffort['elapsed_time'];
    var runTimeLabel = bestEffort["elapsed_time"].toString().toHHMMSS();
    dates.push(date);
    runTimes.push(runTime);
    runTimeLabels.push(runTimeLabel);
  });

  var ctx = $("#progression-chart").get(0).getContext("2d");
  ctx.canvas.height = 300;

  var data = {
    yLabels: runTimeLabels,
    labels: dates,
    datasets: [
      {
        label: "Best Efforts for " + distanceName,
        fill: false,
        lineTension: 0,
        backgroundColor: "rgba(75,192,192,0.4)",
        borderColor: "#FC4C02",
        borderCapStyle: 'butt',
        borderDash: [],
        borderDashOffset: 0.0,
        borderJoinStyle: 'miter',
        pointBorderColor: "#FC4C02",
        pointBackgroundColor: "#fff",
        pointBorderWidth: 1,
        pointHoverRadius: 5,
        pointHoverBackgroundColor: "#FC4C02",
        pointHoverBorderColor: "#E34402",
        pointHoverBorderWidth: 2,
        pointRadius: 4,
        pointHitRadius: 10,
        data: runTimes,
        spanGaps: false
      }
    ]
  };
  var myLineChart = new Chart(ctx, {
    type: 'line',
    data: data,
    options: {
      legend: {
        display: false
      },
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        xAxes: [{
            gridLines: {
                display: false
            },
            type: 'time',
            time: {
                unit: 'month'
            }
        }],
        yAxes: [{
          gridLines: {
              display: true,
              offsetGridLines: true
          },
          ticks: {
            callback: function(value, index, values) {
                return value.toString().toHHMMSS();
            }
          }
        }]
      },
      tooltips: {
        enabled: true,
        mode: 'single',
        callbacks: {
          title: function(tooltipItem, data) {
            return "Best Effort for " + distanceName;
          },
          label: function(tooltipItem, data) {
            var text = "Ran " + tooltipItem.yLabel.toString().toHHMMSS();
            text += " on " + tooltipItem.xLabel;
            return text;
          }
        }
      }
    }
  });
}

function constructBestEffortTableHtml(distance, bestEfforts, maxItemsAllowed, isOverview) {
  var distanceName = distance.replace(/-/g, ' ');

  var table = "<div class='row'><div class='col-xs-12'><div class='box'>"
  if (isOverview) {
    table += "<div class='box-header'><h3 class='box-title'>" + distanceName + "</h3></div>";
  }
  table += "<div class='box-body'>";
  table += "<table class='best-effort-table " + (isOverview ? " " : "datatable ") +
    "table table-bordered table-striped'>";
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
  bestEfforts.reverse().slice(0, maxItemsAllowed).forEach(function(bestEffort) {
    table += "<tr>";
    table += "<td>" + bestEffort["start_date"].slice(0, 10) + "</td>";
    table += "<td class='text-center badge-cell'>" + createWorkoutTypeBadge(bestEffort["workout_type"]) + "</td>";
    table += "<td>" + "<a href='https://www.strava.com/activities/" + bestEffort['activity_id'] +
      "' target='_blank'>" + bestEffort['activity_name'] + "</a>" + "</td>";
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

function createWorkoutTypeChart(distance, bestEfforts) {
  var workoutTypes = {}; // Holds Workout Type and its count.
  bestEfforts.forEach(function(bestEffort) {
    var workoutType = bestEffort["workout_type"];

    // No workout type is a normal run.
    if (workoutType == null) {
      workoutType = 0;
    }

    if (workoutType in workoutTypes) {
      workoutTypes[workoutType] += 1;
    } else {
      workoutTypes[workoutType] = 1;
    }
  });

  var ctx = $("#workout-type-chart").get(0).getContext("2d");
  ctx.canvas.height = 300;

  var data = {
      labels: [
          "Run",
          "Race",
          "Long Run",
          "Workout"
      ],
      datasets: [
      {
          data: [workoutTypes[0], workoutTypes[1], workoutTypes[2], workoutTypes[3]],
          backgroundColor: [
              "rgba(189, 214, 186, 0.7)",
              "rgba(245, 105, 84, 0.7)",
              "rgba(0, 166, 90, 0.7)",
              "rgba(243, 156, 18, 0.7)"
          ],
          hoverBackgroundColor: [
              "rgba(189, 214, 186, 1)",
              "rgba(245, 105, 84, 1)",
              "rgba(0, 166, 90, 1)",
              "rgba(243, 156, 18, 1)"
          ]
      }]
  };

  var chart = new Chart(ctx, {
    type: 'pie',
    data: data,
    options: {
      legend: {
        position: 'bottom',
        onClick: function (e) {
          e.stopPropagation();
        }
      },
      responsive: true,
      maintainAspectRatio: false
    }
  });
}

function createGearChart(distance, bestEfforts) {
  var gears = {}; // Holds Workout Type and its count.
  bestEfforts.forEach(function(bestEffort) {
    var gearName = 'n/a';
    if (bestEffort['gear_name']) {
      gearName = bestEffort['gear_name'];
    }

    if (gearName in gears) {
      gears[gearName] += 1;
    } else {
      gears[gearName] = 1;
    }
  });

  var ctx = $("#gear-chart").get(0).getContext("2d");
  ctx.canvas.height = 300;

  var gearLabels = Object.keys(gears);
  var gearCount = [];
  for(var key in gears) {
    var value = gears[key];
    gearCount.push(value);
  }
  var data = {
      labels: gearLabels,
      datasets: [
      {
          data: gearCount,
          backgroundColor: [
              "rgba(189, 214, 186, 0.7)",
              "rgba(245, 105, 84, 0.7)",
              "rgba(0, 166, 90, 0.7)",
              "rgba(243, 156, 18, 0.7)"
          ],
          hoverBackgroundColor: [
              "rgba(189, 214, 186, 1)",
              "rgba(245, 105, 84, 1)",
              "rgba(0, 166, 90, 1)",
              "rgba(243, 156, 18, 1)"
          ]
      }]
  };

  var chart = new Chart(ctx, {
    type: 'pie',
    data: data,
    options: {
      legend: {
        position: 'bottom',
        onClick: function (e) {
          e.stopPropagation();
        }
      },
      responsive: true,
      maintainAspectRatio: false
    }
  });
}

/* Create Strava Workout Type badge <span>. Run, Race, Long Run and Workout. */
function createWorkoutTypeBadge(workoutType) {
  var workoutTypeClass = "run light-color-zone";
  var workoutTypeName = "Run";
  if (workoutType === 1) {
    workoutTypeClass = "race";
    workoutTypeName = "Race";
  }
  if (workoutType === 2) {
    workoutTypeClass = "long-run";
    workoutTypeName = "Long Run";
  }
  if (workoutType === 3) {
    workoutTypeClass = "workout";
    workoutTypeName = "Workout";
  }
  return "<span class='label workout-type-" + workoutTypeClass + "'>" + workoutTypeName + "</span>";
}

/* Create HR badge <span> based on my reserve HR zones. TODO: Need extend to get custom zones. */
function createHeartRateBadge(heartRate) {
  var hrZoneClass = "hr-zone-na";
  if (heartRate === 0) {
    heartRate = "n/a";
  }
  if (heartRate < 130) {
    hrZoneClass = "hr-zone-1 light-color-zone";
  }
  else if (heartRate > 130 && heartRate <= 143) { // HRR 50% - 60%
    hrZoneClass = "hr-zone-1";
  }
  else if (heartRate > 143 && heartRate <= 156) { // HRR 60% - 70%
    hrZoneClass = "hr-zone-2 light-color-zone";
  }
  else if (heartRate > 156 && heartRate <= 163) { // HRR 70% - 75%
    hrZoneClass = "hr-zone-2";
  }
  else if (heartRate > 163 && heartRate <= 169) { // HRR 75% - 80%
    hrZoneClass = "hr-zone-3";
  }
  else if (heartRate > 169 && heartRate <= 176) { // HRR 80% - 85%
    hrZoneClass = "hr-zone-4";
  }
  else if (heartRate > 176 && heartRate <= 182) { // HRR 85% - 90%
    hrZoneClass = "hr-zone-5";
  }
  else if (heartRate > 182 && heartRate <= 189) { // HRR 90% - 95%
    hrZoneClass = "hr-zone-6";
  }
  else if (heartRate > 189 && heartRate <= 195) { // HRR 95% - 100%
    hrZoneClass = "hr-zone-7";
  }
  else if (heartRate > 195) { // HRR 100%
    hrZoneClass = "hr-zone-8";
  }
  return "<span class='badge " + hrZoneClass + "'>" + heartRate + "</span>";
}

/* Extension method to convert a number into time format. */
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

/* Get a random colour. */
function getRandomColor() {
  var letters = '0123456789ABCDEF'.split('');
  var color = '#';
  for (var i = 0; i < 6; i++ ) {
      color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}
