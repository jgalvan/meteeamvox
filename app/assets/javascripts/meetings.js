$(document).ready(function() {
  $('.datepicker').pickadate({
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 15, // Creates a dropdown of 15 years to control year,
    today: 'Today',
    clear: 'Clear',
    close: 'Ok',
    closeOnSelect: false // Close upon selecting a date,
    });

    var interval;

    $("#start-btn").on('click', function () {
        $(this).hide();
        $("#stop-btn").show();
        $(function () {
            interval = setInterval(function () {
                $("#stop-btn").toggleClass("blink");
            }, 500);
        });
    });

    $("#stop-btn").on('click', function () {
        $(this).hide();
        clearInterval(interval);
        // $("#start-btn").show();
        $(".preloader-wrapper").show();
    });

    $("#stop-btn").hide();
    $(".preloader-wrapper").hide();

    $("#add-meeting-collaborator").select2({
        placeholder: "Share with friends...",
        allowClear: false,
        openOnEnter: false,
        minimumInputLength: 3,
        minimumResultsForSearch: 1,
        width: "40%"
    });

    $("#add-team").select2({
        placeholder: "Share with team...",
        allowClear: false,
        openOnEnter: false,
        minimumInputLength: 3,
        minimumResultsForSearch: 1,
        width: "40%"
      });

    $('#invite-type').click(function() {
        $("#add-meeting-collaborators-section").toggle(!this.checked);
        $("#add-team-section").toggle(this.checked);
    });
});


  // Expose globally your audio_context, the recorder instance and audio_stream
  var audio_context;
  var recorder;
  var audio_stream;

  /**
   * Patch the APIs for every browser that supports them and check
   * if getUserMedia is supported on the browser. 
   * 
   */
  function Initialize() {
      try {
          // Monkeypatch for AudioContext, getUserMedia and URL
          window.AudioContext = window.AudioContext || window.webkitAudioContext;
          navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia;
          window.URL = window.URL || window.webkitURL;

          console.log(navigator);
          // Store the instance of AudioContext globally
          audio_context = new AudioContext;
          console.log('Audio context is ready !');
          console.log('navigator.getUserMedia ' + (navigator.getUserMedia ? 'available.' : 'not present!'));
      } catch (e) {
          alert('No web audio support in this browser!');
      }
  }

  /**
   * Starts the recording process by requesting the access to the microphone.
   * Then, if granted proceed to initialize the library and store the stream.
   *
   * It only stops when the method stopRecording is triggered.
   */
  function startRecording() {
      // Access the Microphone using the navigator.getUserMedia method to obtain a stream
      navigator.getUserMedia({ audio: true }, function (stream) {
          // Expose the stream to be accessible globally
          audio_stream = stream;
          // Create the MediaStreamSource for the Recorder library
          var input = audio_context.createMediaStreamSource(stream);
          console.log('Media stream succesfully created');

          // Initialize the Recorder Library
          recorder = new Recorder(input);
          console.log('Recorder initialised');

          // Start recording !
          recorder && recorder.record();
          console.log('Recording...');

          // Disable Record button and enable stop button !
          document.getElementById("start-btn").disabled = true;
          document.getElementById("stop-btn").disabled = false;
      }, function (e) {
          console.error('No live audio input: ' + e);
          alert("Please accept use of microphone :)");
      });
  }

  /**
   * Stops the recording process. The method expects a callback as first
   * argument (function) executed once the AudioBlob is generated and it
   * receives the same Blob as first argument. The second argument is
   * optional and specifies the format to export the blob either wav or mp3
   */
  function stopRecording(callback, AudioFormat) {
      // Stop the recorder instance
      recorder && recorder.stop();
      console.log('Stopped recording.');

      // Stop the getUserMedia Audio Stream !
      audio_stream.getAudioTracks()[0].stop();

      // Disable Stop button and enable Record button !
      document.getElementById("start-btn").disabled = false;
      document.getElementById("stop-btn").disabled = true;

      // Use the Recorder Library to export the recorder Audio as a .wav file
      // The callback providen in the stop recording method receives the blob
      if(typeof(callback) == "function"){

          /**
           * Export the AudioBLOB using the exportWAV method.
           * Note that this method exports too with mp3 if
           * you provide the second argument of the function
           */
          recorder && recorder.exportWAV(function (blob) {
              callback(blob);

              // create WAV download link using audio data blob
              // createDownloadLink();

              // Clear the Recorder to start again !
              recorder.clear();
          }, (AudioFormat || "audio/wav"));
      }
  }

  // Initialize everything once the window loads
  window.onload = function(){
      if(document.getElementById("transcript-text") != null) {
        // Prepare and check if requirements are filled
      Initialize();
      
            // Handle on start recording button
            document.getElementById("start-btn").addEventListener("click", function(){
                startRecording();
            }, false);
      
            // Handle on stop recording button
            document.getElementById("stop-btn").addEventListener("click", function(){
                // Use wav format
                var _AudioFormat = "audio/wav";
                // You can use mp3 to using the correct mimetype
                //var AudioFormat = "audio/mpeg";
      
                stopRecording(function(AudioBLOB){
                    var data = new FormData();
                    data.append("audio", AudioBLOB, (new Date()).getTime() + ".wav");
      
                    var oReq = new XMLHttpRequest();
                    if($(".test-try").length == 0) {
                        data.append("id", $('#meeting-title').attr("class"));
                        oReq.open("POST", "/meetings/upload_audio");
                    }
                    else {
                        data.append("test", "true");
                        oReq.open("POST", "/upload_audio");
                    }
                    oReq.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
                    oReq.send(data);
                    oReq.onload = function(oEvent) {
                        if (oReq.status == 200) {
                            console.log("Uploaded");
                            $("#transcript-text").text(JSON.parse(oEvent.currentTarget.response).transcript);
                            $(".preloader-wrapper").hide();
                            $("#start-btn").show();
                        } else {
                            console.log("Error " + oReq.status + " occurred uploading your file.");
                        }
                    };
                }, _AudioFormat);
            }, false);
      }
  };