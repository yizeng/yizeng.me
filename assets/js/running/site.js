String.prototype.toHHMMSS = function () {
  var sec_num = parseInt(this, 10); // Don't forget the second param.
  var hours   = Math.floor(sec_num / 3600);
  var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
  var seconds = sec_num - (hours * 3600) - (minutes * 60);

  if (hours   < 10) {
    hours   = "0" + hours;
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

$(document).ready(function() {
  // Retrieve and parse data from JSON file, then build table.
  $.getJSON("/data.json").then(function(data) {
    var bestEffortsJsonData = [];
    $.each(data, function(key, value) {
        bestEffortsJsonData.push(value);
    });

    // i.e. Distance.
    var bestEffortNames = ['50k', 'Marathon', '30k', 'Half-Marathon', '20k', '10 mile', '15k', '10k', '5k', '2 mile', '1 mile', '1k', '1/2 mile', '400m'];
    bestEffortNames.forEach(function(distance) {

      var bestEfforts = [];
        bestEffortsJsonData.forEach(function(bestEffort) {
          if (bestEffort['name'] === distance && bestEffort['pr_rank'] === 1) {
            bestEfforts.push(bestEffort);
          }
        });

      if (bestEfforts.length > 0) {
        var distanceId = distance.toLowerCase().replace(/ /g,"-").replace(/\//g,"-");
        var anchor = '<li><a href="#' + distanceId + '" class="skel-layers-ignoreHref">' + distance + '</a></li>';

        var section = '<section id="' + distanceId + '">';
        section += '<div class="container">';
        section += '<table class="rwd-table"><thead><tr><th>Date</th><th>Activity</th><th>Distance</th><th>Time</th><th>Gear</th></tr></thead>';

        bestEfforts.reverse().forEach(function(bestEffort) {
          section += "<tr>";
          section += '<td data-th="Date">' + bestEffort['start_date'].slice(0, 10); + '</td>';
          section += '<td data-th="Activity"><a href="https://www.strava.com/activities/' + bestEffort['activity_id'] + '" target="_blank">'+ bestEffort['activity_name'] + '</a></td>';
          section += '<td data-th="Distance">' + bestEffort['name'] + '</td>';
          section += '<td data-th="Time">' + bestEffort['elapsed_time'].toString().toHHMMSS() + '</td>';

          var gearName = '-';
          if (bestEffort['gear_name']) {
            gearName = bestEffort['gear_name'];
          }
          section += '<td data-th="Gear">' + gearName + '</td>';
          section += "</tr>";
        });

        section += '</table>';
        section += '</div>';
        section += '</section>';
        $('#nav ul').append(anchor);
        $('#main').append(section);
      }
    });
  });
});