

#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <cstdlib>
#include <cstdio>
#include <cctype>
#include <tag.h>
#include <fileref.h>

#include "TagConverter.h"

// The tagToFilename_ method reads the a file's tags, and using the user-
// provided format string, returns a new target filename which will (hopefully)
// become the new filename.

std::string TagConverter::tagToFilename_( const TagLib::Tag &tag,
                                                std::string format ) const
{
  char temp[1024];
  size_t pos=0;
  pos = format.find("%");
  while ( pos != std::string::npos )
  {
    switch( format[pos+1] )
    {
      case 'n':
        format.replace(pos, 2, tag.title().toCString());
        pos += tag.title().length();
        break;
        
      case 'a':
        format.replace(pos, 2, tag.artist().toCString());
        pos += tag.artist().length();
        break;
        
      case 'b':
        format.replace(pos, 2, tag.album().toCString());
        pos += tag.album().length();
        break;
        
      case 'g':
        format.replace(pos, 2, tag.genre().toCString());
        pos += tag.genre().length();
        break;
        
      case 'c':
        format.replace(pos, 2, tag.comment().toCString());
        pos += tag.comment().length();
        break;
			
      case 'y':
        sprintf(temp, "%d", tag.year());
        format.replace(pos, 2, temp);
        pos += strlen(temp);
        break;

      case 't':
        sprintf(temp, "%02d", tag.track());
        format.replace(pos, 2, temp);
        pos += strlen(temp);
        break;
        
      default:
        return "";
    }
    pos = format.find("%", pos);
  }
  
  return format;  
}

// The filenameToTag method is a publicly-accessable wrapper to the private
// filenameToTag_() function, which simply deals with cases in which the file is
// no longer valid, then calls filenameToTag_().

int TagConverter::filenameToTag( std::string filename,
								std::string format )
{
	int success = 0;
	TagLib::FileRef f(filename.c_str());
	if ( f.isNull() )
	{
		std::cerr << "Error: could not open file " << filename << std::endl;
		success = -1;
	}
	else if ( filenameToTag_(*f.tag(), filenameShort(filename), format) < 0 )
	{
		std::cerr << "Error: formatting string is bad!\n\n";
		success = -1;
	}
	else
	{
		f.save();
	}
	return success;
}

// The filenameToTag_ method reads a filename and a user-provided format string,
// and attempts to use the format string to read tag information from the
// filename. If successful in parsing the filename, it updates the tag
// information accordingly using TagLib.

int TagConverter::filenameToTag_( TagLib::Tag &tag,
                                      std::string filename, std::string format )
{
  size_t pos1, pos2;
  char type;
  int temp_int;
  char temp_str[1024]={0};
  std::string temp_str2;
  std::string token;
  std::string temp_token;
  char extract[1024] = {0};
  char *extract_ptr;
  
  filename = filename.substr(0, filename.rfind("."));
  
  pos1 = format.find("%");
  
  while (pos1 != std::string::npos && filename.length())
  {
    pos2 = format.find("%", pos1+1);
    if (pos2 != std::string::npos)
    {
      token = format.substr(0, pos2);
    }
    else
    {
      token = format;
    }
    
    switch (token[pos1+1])
    {
      case 'n':
      case 'a':
      case 'b':
      case 'g':
      case 'c':
        type = token[pos1+1];
        token[pos1+1] = 's';
        if (pos2 == std::string::npos)
        {
          if (pos1 > 0)
          {
            size_t temp_pos;
            temp_pos = toLower(filename).find
            ( toLower(trimWhitespace(format.substr(0, pos1))) );
            if (temp_pos != std::string::npos)
            {
              filename = filename.substr( temp_pos+1 );
            }
          }
          std::string formatsubstr = format.substr(pos1+2);
          size_t temp_pos = toLower(filename).rfind(toLower(formatsubstr));
          if (temp_pos != std::string::npos && formatsubstr.length())
          {
            filename = trimWhitespace(filename.substr(0, temp_pos));
            strncpy( temp_str, filename.c_str(), 1024 );
          }
          else
          {
            filename = trimWhitespace(filename);
            strncpy( temp_str, filename.c_str(), 1024 );
          }
        }
        else 
        {
          temp_token = trimWhitespace(token.substr(pos1+2));
          if (temp_token.length())
          {
            size_t temp_pos = toLower(filename).find(toLower(temp_token),
                                                     pos1)-pos1;
            temp_str2 = filename.substr(pos1, temp_pos);
            temp_str2 = trimWhitespace( temp_str2 );
            strncpy( temp_str, temp_str2.c_str(), 1024 );
            extract_ptr = temp_str;
          }
          else
          {
            sscanf( filename.c_str(), token.c_str(), temp_str );
            extract_ptr = temp_str;
          }
        }
        if ( strlen(temp_str) )
        {
          switch (type)
          {
            case 'n':
              tag.setTitle(temp_str);
              break;
            case 'a':
              tag.setArtist(temp_str);
              break;
            case 'b':
              tag.setAlbum(temp_str);
              break;
            case 'g':
              tag.setGenre(temp_str);
              break;
            case 'c':
              tag.setComment(temp_str);
              break;
          }
        }
        break;
      case 'y':
        token[pos1+1] = 'd';
        if ( sscanf( filename.c_str(), token.c_str(), &temp_int ) )
        {
          sprintf(extract, "%d", temp_int);
          extract_ptr = extract;
          tag.setYear(temp_int);
        }
        else
        {
          memset( extract_ptr, 0, 1024 );
        }
        break;
      case 't':
        token[pos1+1] = 'd';
        if ( sscanf( filename.c_str(), token.c_str(), &temp_int ) )
        {
          sprintf(extract, "%d", temp_int);
          extract_ptr = extract;
          tag.setTrack(temp_int);
        }
        else
        {
          memset( extract_ptr, 0, 1024 );
        }
        break;
      default:
        return -1;
    } // switch
    filename = filename.substr(filename.find(extract_ptr)+strlen(extract_ptr));
    format = format.substr(pos1+2);
    
    pos1 = format.find("%", 1);
  } // while
  
  return 0;  
}

// The trimWhitespace() function simply removes leading and trailing spaces,
// newlines, and tab characters from the provided source string.

std::string TagConverter::trimWhitespace( std::string str )
{
  str = str.erase( str.find_last_not_of(" \t\n") + 1);
  str = str.erase( 0, str.find_first_not_of(" \t\n") );
  return str;
}

// The toLower() function returns a lowercase version of the provided source
// string.

std::string TagConverter::toLower( std::string str )
{
  std::transform( str.begin(), str.end(), str.begin(),
                 (int(*)(int)) std::tolower );
  return str;
}

// The filenameShort() function removes any leading path to the filename.

std::string TagConverter::filenameShort( std::string filename )
{
  size_t pos = filename.rfind("/");
  if ( pos != std::string::npos )
  {
    return filename.erase( 0, pos+1 );
  }
  else
  {
    return filename;
  }
}

// The getExtension() function returns any text after the last '.' (period) in
// the provided filename.

std::string TagConverter::getExtension( std::string filename )
{
  size_t pos;
  pos = filename.rfind(".");
  if ( pos != std::string::npos )
  {
    return filename.substr( pos+1 );
  }
  return "";
}

// The getPath() function returns any leading path to the provided filename.

std::string TagConverter::getPath( std::string filename )
{
  size_t pos;
  pos = filename.rfind("/");
  if ( pos != std::string::npos )
  {
    return filename.substr( 0, pos );
  }
  return "";
}