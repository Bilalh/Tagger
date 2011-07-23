
#include <iostream>
#include <stdlib.h>

#include <tbytevector.h>

#include <mpegfile.h>

#include <id3v2tag.h>
#include <id3v2frame.h>
#include <id3v2header.h>

#include <id3v1tag.h>

#include <apetag.h>

#include <mp4tag.h>
#include <mp4file.h>

using namespace std;
using namespace TagLib;

int main(int argc, char *argv[]) {
	// process the command line args
	for(int i = 1; i < argc; i++) {

		cout << "******************** \"" << argv[i] << "\"********************" << endl;
		MP4:
		MPEG::File f(argv[i]);
		
		ID3v2::Tag *id3v2tag = f.ID3v2Tag();

		if(id3v2tag) {

			cout << "ID3v2."
				 << id3v2tag->header()->majorVersion()
				 << "."
				 << id3v2tag->header()->revisionNumber()
				 << ", "
				 << id3v2tag->header()->tagSize()
				 << " bytes in tag"
				 << endl;

			ID3v2::FrameList::ConstIterator it = id3v2tag->frameList().begin();
			for(; it != id3v2tag->frameList().end(); it++)
				cout << (*it)->frameID() << " - \"" << (*it)->toString() << "\"" << endl;
		} else
			cout << "file does not have a valid id3v2 tag" << endl;
			
	}
}
