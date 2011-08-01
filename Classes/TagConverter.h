
#ifndef TAGCONVERTER_H
#define TAGCONVERTER_H

#include <string>
#include <tag.h>

// The TagConverter class provides batch filename and tagging methods using
// a user-provided format string. Tag I/O is accomplished using the TagLib C++
// library.

class TagConverter
{
public:
   int filenameToTag( std::string filename, std::string format );
   std::string tagToFilename( std::string filename, std::string format );
  
   int filenameToTag_( TagLib::Tag &tag, std::string filename, 
                        std::string format );

   std::string tagToFilename_( const TagLib::Tag &tag, std::string format ) const;

protected:
  std::string trimWhitespace( std::string str );
  std::string toLower( std::string str );
  std::string filenameShort( std::string filename );
  std::string getExtension( std::string filename );
  std::string getPath( std::string filename );
};

#endif