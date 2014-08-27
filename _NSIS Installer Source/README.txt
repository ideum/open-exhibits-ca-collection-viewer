The Maxwell version of the Collective Access (CA) Collection Viewer (CV) has substantial differences compared to previous versions; there are a few intricacies as a result.

The CA web interface (for adding/editing single objects) has been modified to show only necessary fields. The field values should be obvious, but care must taken when changing media representations (if and only if the object has a primary AND secondary media representation).

If such an object needs to have either representation changed, both representations must first be deleted (in the web interface). Next, the primary media representation must be added FOLLOWED by the second (see CA Media Rep Example.png, match the "Type" and "Is Primary?" fields and ignore the "Status" and "Access" fields).

Dial fields may ONLY be composed of word characters, whitespace, underscores, or commas, otherwise search filters break (this is a CA 1.3 bug, addressed in 1.4+).

If any object in the CA database has one or more dial field changed to a value which is not used by any other object, the python CML updater script (CVCFU.py) must be run. The script updates dial combination strings in the CML definitions for the dock(s), based on all dial field values found in the database. These combinations are used for search filtering in the CV.

Videos should be 720p.
Images must be JPGs, at most 1080p.
Audio should be in the MP3 format (max bitrate 320kbps).

******* READ THIS IF IT'S THE ONLY PART OF THIS FILE YOU READ *******
If CA search results get out-of-whack, go to Manage->Administration->Maintenance->Rebuild Search Indices. Don't access CA in any way until the process fully completes (usually around 5 minutes).

Be sure to open up XAMPP and wait for Apache to show ports 80 and 443 in use. The index rebuilding process erroneously reports that it has finished when in fact is has not; during indexing Apache uses a port typically in the 5000-7000 range, when it switches back to 80 and 443, indexing is actually complete.

If you don't allow the process to complete you WILL break all searches until you restart the process (and allow it to fully complete)!
*******