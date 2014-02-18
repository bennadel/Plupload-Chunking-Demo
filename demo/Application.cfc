component
	output = false
	hint = "I define the application settings and event handlers."
	{

	// Define the application settings.
	this.name = hash( getCurrentTemplatePath() );
	this.applicationTimeout = createTimeSpan( 0, 0, 10, 0 );
	this.sessionManagement = false;

	// Get application root directory for mappings.
	this.directory = getDirectoryFromPath( getCurrentTemplatePath() );

	// Configure application mappgins. In this case, we'll be using the uploads and chunks
	// mapping with the expandPath() function later on when saving files.
	this.mappings[ "/uploads" ] = ( this.directory & "uploads/" );
	this.mappings[ "/chunks" ] = ( this.directory & "chunks/" );

}