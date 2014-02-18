<!doctype html>
<html>
<head>
	<meta charset="utf-8" />

	<title>
		Chunking File Uploads With Plupload And ColdFusion
	</title>

	<link rel="stylesheet" type="text/css" href="./assets/css/styles.css"></link>
</head>
<body>

	<h1>
		Chunking File Uploads With Plupload And ColdFusion
	</h1>

	<div id="uploader" class="uploader">

		<a id="selectFiles" href="##">

			<span class="label">
				Select Files
			</span>

			<span class="standby">
				Waiting for files...
			</span>

			<span class="progress">
				Uploading - <span class="percent"></span>%
			</span>

		</a>

	</div>


	<!-- Load and initialize scripts. -->
	<script type="text/javascript" src="./assets/jquery/jquery-2.1.0.min.js"></script>
	<script type="text/javascript" src="./assets/plupload/js/plupload.full.min.js"></script>
	<script type="text/javascript">

		(function( $, plupload ) {

			// Find and cache the DOM elements we'll be using.
			var dom = {
				uploader: $( "#uploader" ),
				percent: $( "#uploader span.percent" )
			};


			// Instantiate the Plupload uploader.
			var uploader = new plupload.Uploader({

				// Try to load the HTML5 engine and then, if that's not supported, the Flash 
				// fallback engine.
				// --
				// NOTE: I had read that Chunking was not available in the Flash runtime; however,
				// after forcing the Flash runtime, it seems that chunking IS available, but is 
				// significantly slower than it is in the html5 runtime. 
				runtimes: "html5,flash",

				// The upload URL - this is where chunks OR full files will go.
				url: "./upload.cfm",

				// The ID of the drop-zone element.
				drop_element: "uploader",

				// To enable click-to-select-files, you can provide a browse button. We can
				// use the same one as the drop zone.
				browse_button: "selectFiles",

				// For the Flash engine, we have to define the ID of the node into which 
				// Pluploader will inject the <OBJECT> tag for the flash movie.
				container: "uploader",

				// The URL for the SWF file for the Flash upload runtime for browsers that 
				// don't support HTML5.
				flash_swf_url: "./assets/plupload/js/Moxie.swf",

				// Needed for the Flash environment to work.
				urlstream_upload: true,

				// The name of the form-field that will hold the upload data. 
				file_data_name: "file",

				// Send any additional params (ie, multipart_params) in multipart message
				// format.
				multipart: true,

				// This defines the maximum size that each file chunk can be.
				// --
				// NOTE: I'm setting it particularly low for the demo. In general, you don't 
				// want it to be too small because the chunking has a performance hit. Chunking
				// is meant for fault-tolerance and browser limitations. 
				chunk_size: "100kb",

				// If the upload of a chunk fails, this is the number of times the chunk
				// should be re-uploaded before the upload (overall) is considered a failure.
				max_retries: 3

			});


			// Set up the event handlers for the uploader.
			uploader.bind( "Init", handlePluploadInit );
			uploader.bind( "Error", handlePluploadError );
			uploader.bind( "FilesAdded", handlePluploadFilesAdded );
			uploader.bind( "QueueChanged", handlePluploadQueueChanged );
			uploader.bind( "BeforeUpload", handlePluploadBeforeUpload );
			uploader.bind( "UploadProgress", handlePluploadUploadProgress );
			uploader.bind( "ChunkUploaded", handlePluploadChunkUploaded );
			uploader.bind( "FileUploaded", handlePluploadFileUploaded );
			uploader.bind( "StateChanged", handlePluploadStateChanged );
			
			// Initialize the uploader (it is only after the initialization is complete that 
			// we will know which runtime load: html5 vs. Flash).
			uploader.init();


			// ------------------------------------------ //
			// ------------------------------------------ //


			// I provide access to the uploader and the file right before the upload is about 
			// to being. This allows for just-in-time altering of the settings.
			function handlePluploadBeforeUpload( uploader, file ) {
			
				console.log( "Upload about to start.", file.name );
				
			}

			
			// I handle the successful upload of one of the chunks (of a larger file).
			function handlePluploadChunkUploaded( uploader, file, info ) {
			
				console.log( "Chunk uploaded.", info.offset, "of", info.total, "bytes." );				

			}


			// I handle any errors raised during uploads.
			function handlePluploadError() {
				
				console.warn( "Error during upload." );

			}


			// I handle the files-added event. This is different that the queue-changed event.
			// At this point, we have an opportunity to reject files from the queue.
			function handlePluploadFilesAdded( uploader, files ) {

				console.log( "Files selected." );
				// Example: file.splice( 0, 1 ).

			}


			// I handle the successful upload of a whole file. Even if a file is chunked,
			// this handler will be called with the same response provided to the last
			// chunk success handler.
			function handlePluploadFileUploaded( uploader, file, response ) {
			
				console.log( "Entire file uploaded.", response );

			}


			// I handle the init event. At this point, we will know which runtime has loaded,
			// and whether or not drag-drop functionality is supported.
			function handlePluploadInit( uploader, params ) {

				console.log( "Initialization complete." );
				console.info( "Drag-drop supported:", !! uploader.features.dragdrop );

			}


			// I handle the queue changed event.
			function handlePluploadQueueChanged( uploader ) {

				console.log( "Files added to queue." );

				if ( uploader.files.length && isNotUploading() ){

					uploader.start();

				}

			}


			// I handle the change in state of the uploader.
			function handlePluploadStateChanged( uploader ) {

				if ( isUploading() ) {

					dom.uploader.addClass( "uploading" );

				} else {

					dom.uploader.removeClass( "uploading" );

				}

			}


			// I handle the upload progress event. This gives us the progress of the given 
			// file, NOT of the entire upload queue.
			function handlePluploadUploadProgress( uploader, file ) {

				console.info( "Upload progress:", file.percent );

				dom.percent.text( file.percent );

			}


			// I determine if the upload is currently inactive.
			function isNotUploading() {

				var currentState = uploader.state;

				return( currentState === plupload.STOPPED );

			}


			// I determine if the uploader is currently uploading a file (or if it is inactive).
			function isUploading() {

				var currentState = uploader.state;

				return( currentState === plupload.STARTED );

			}

		})( jQuery, plupload );

	</script>

</body>
</html>