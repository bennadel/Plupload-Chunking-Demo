
# Chunking File Uploads With Plupload And ColdFusion

by [Ben Nadel][bennadel] (on [Google+][googleplus])

By default, files uploaded using [Plupload][plupload] are uploaded in their entirety 
within a single form post. However, Plupload does have the ability to chunk files. When
a file is chunked, it is split up into multiple parts, each of which is posted to the 
server independently. The server then has to rebuild the target file using the received
chunks.

This is meant to deal with browser limitations and to allow for some fault tolerance in
the file upload; in addition to the chunking, you can tell Plupload to retry failed 
uploads a given number of times. This way, if there is a momentary network problem, 
Plupload may still successfully upload the chunk, and eventually, the entire file.


[bennadel]: http://www.bennadel.com
[googleplus]: https://plus.google.com/108976367067760160494?rel=author
[plupload]: http://plupload.com