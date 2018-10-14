/*
  The code for finding out the BPM / tempo is taken from this post:
  http://tech.beatport.com/2014/web-audio/beat-detection-using-web-audio/
 */

'use strict';

var queryInput = document.querySelector('#query'),
    result = document.querySelector('#result'),
    timestamp = document.querySelector('#timestamp'),
    text = document.querySelector('#text'),
    audioTag = document.querySelector('#audio'),
    playButton = document.querySelector('#play');

//duration is set up based on the buffer.duration
var duration = -1;
var fixedLength = 30;

function updateProgressState() {
    if (audioTag.paused) {
      return;
  }
  var progressIndicator = document.querySelector('#progress');
    console.log("Progress!!1", audioTag.currentTime);
  if (progressIndicator && duration) {
    progressIndicator.setAttribute('x', (audioTag.currentTime * 100 / fixedLength) + '%');
  }
  requestAnimationFrame(updateProgressState);
}

audioTag.addEventListener('play', updateProgressState);
audioTag.addEventListener('playing', updateProgressState);

function updatePlayLabel() {
    //console.log("Updating play label new", audioTag.paused);
  playButton.innerHTML = audioTag.paused ? 'Play track' : 'Pause track';
}

audioTag.addEventListener('play', updatePlayLabel);
audioTag.addEventListener('playing', updatePlayLabel);
audioTag.addEventListener('pause', updatePlayLabel);
audioTag.addEventListener('ended', updatePlayLabel);

playButton.addEventListener('click', function() {
  if (audioTag.paused) {
    audioTag.play();
  } else {
    audioTag.pause();
  }
});

result.style.display = 'none';

function getPeaks(data) {

  // What we're going to do here, is to divide up our audio into parts.

  // We will then identify, for each part, what the loudest sample is in that
  // part.

  // It's implied that that sample would represent the most likely 'beat'
  // within that part.

  // Each part is 0.5 seconds long - or 22,050 samples.

  // This will give us 60 'beats' - we will only take the loudest half of
  // those.

  // This will allow us to ignore breaks, and allow us to address tracks with
  // a BPM below 120.

  var partSize = 22050,
      parts = data[0].length / partSize,
      peaks = [];

  for (var i = 0; i < parts; i++) {
    var max = 0;
    for (var j = i * partSize; j < (i + 1) * partSize; j++) {
      var volume = Math.max(Math.abs(data[0][j]), Math.abs(data[1][j]));
      if (!max || (volume > max.volume)) {
        max = {
          position: j,
          volume: volume
        };
      }
    }
    peaks.push(max);
  }

  // We then sort the peaks according to volume...

  peaks.sort(function(a, b) {
    return b.volume - a.volume;
  });

  // ...take the loundest half of those...

  peaks = peaks.splice(0, peaks.length * 0.5);

  // ...and re-sort it back based on position.

  peaks.sort(function(a, b) {
    return a.position - b.position;
  });

  return peaks;
}

function getIntervals(peaks) {

  // What we now do is get all of our peaks, and then measure the distance to
  // other peaks, to create intervals.  Then based on the distance between
  // those peaks (the distance of the intervals) we can calculate the BPM of
  // that particular interval.

  // The interval that is seen the most should have the BPM that corresponds
  // to the track itself.

  var groups = [];

  peaks.forEach(function(peak, index) {
    for (var i = 1; (index + i) < peaks.length && i < 10; i++) {
      var group = {
        tempo: (60 * 44100) / (peaks[index + i].position - peak.position),
        count: 1,
        position:roundToX(peak.position / 44100, 100)
      };
      console.log("Peak position", roundToX(peak.position / 44100, 100));

      while (group.tempo < 90) {
        group.tempo *= 2;
      }

      while (group.tempo > 180) {
        group.tempo /= 2;
      }

      group.tempo = roundToX(group.tempo, 100);

      if (!(groups.some(function(interval) {
        return (interval.tempo === group.tempo ? interval.count++ : 0);
      }))) {
        groups.push(group);
      }
    }
  });
  return groups;
}

function roundToX(valuez, decimals) {
    return Math.round(valuez*decimals)/decimals;
}


function drawSvg(peaks, buffer) {
    var svg = document.querySelector('#svg');
    svg.innerHTML = '';
    var svgNS = 'http://www.w3.org/2000/svg';
    var rect;
    peaks.forEach(function (peak) {
        rect = document.createElementNS(svgNS, 'rect');
        rect.setAttributeNS(null, 'x', (100 * peak.position / buffer.length) + '%');
        rect.setAttributeNS(null, 'y', 0);
        rect.setAttributeNS(null, 'width', 1);
        rect.setAttributeNS(null, 'height', '100%');
        svg.appendChild(rect);
    });

    rect = document.createElementNS(svgNS, 'rect');
    rect.setAttributeNS(null, 'id', 'progress');
    rect.setAttributeNS(null, 'y', 0);
    rect.setAttributeNS(null, 'width', 1);
    rect.setAttributeNS(null, 'height', '100%');
    svg.appendChild(rect);

    var newText = document.createElementNS(svgNS,"text");
    var x = 100, y=10, val="mordi";
    newText.setAttributeNS(null,"x",x);
    newText.setAttributeNS(null,"y",y);
    newText.setAttributeNS(null,"font-size","20");

    var textNode = document.createTextNode(val);
    newText.appendChild(textNode);
    svg.appendChild(newText);

    svg.innerHTML = svg.innerHTML; // force repaint in some browsers
}

function setUpFilters(offlineContext, buffer) {
// Create buffer source
    var source = offlineContext.createBufferSource();
    source.buffer = buffer;

    // Beats, or kicks, generally occur around the 100 to 150 hz range.
    // Below this is often the bassline.  So let's focus just on that.

    // First a lowpass to remove most of the song.

    var lowpass = offlineContext.createBiquadFilter();
    lowpass.type = "lowpass";
    lowpass.frequency.value = 150;
    lowpass.Q.value = 1;

    // Run the output of the source through the low pass.

    source.connect(lowpass);

    // Now a highpass to remove the bassline.

    var highpass = offlineContext.createBiquadFilter();
    highpass.type = "highpass";
    highpass.frequency.value = 100;
    highpass.Q.value = 1;

    // Run the output of the lowpass through the highpass.

    lowpass.connect(highpass);

    // Run the output of the highpass through our offline context.

    highpass.connect(offlineContext.destination);

    // Start the source, and render the output into the offline conext.

    source.start(0);
    offlineContext.startRendering();
}

document.querySelector('form').addEventListener('submit', function(formEvent) {
  formEvent.preventDefault();
    var audiourl = queryInput.value.trim();
    audioTag.src = audiourl;

      var request = new XMLHttpRequest();
      request.open('GET', audiourl, true);
      request.responseType = 'arraybuffer';
      request.onload = function() {

        // Create offline context
        var OfflineContext = window.OfflineAudioContext || window.webkitOfflineAudioContext;
        var offlineContext = new OfflineContext(2, fixedLength * 44100, 44100);

        offlineContext.decodeAudioData(request.response, function(buffer) {
            setUpFilters(offlineContext, buffer);
            duration = buffer.duration;
        });

        offlineContext.oncomplete = function(e) {
          var buffer = e.renderedBuffer;
          var peaks = getPeaks([buffer.getChannelData(0), buffer.getChannelData(1)]);
          console.log("Peaks", peaks);
          var groups = getIntervals(peaks);
          drawSvg(peaks, buffer);
          var top = groups.sort(function(intA, intB) {
            return intB.count - intA.count;
          }).splice(0, 5);
        text.innerHTML += '<div class="small">Other options are ' +
            top.slice(1).map(function(group) {
              return group.tempo + ' BPM (' + group.count + ') from: ' + group.position;
            }).join(', ') +
            '</div>';
        result.style.display = 'block';
        };
    };
    request.send();
});
