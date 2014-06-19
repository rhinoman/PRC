/*******************************************************************************
*
*   This program is free software: you can redistribute it and/or modify
*   it under the terms of the GNU Lesser General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU Lesser General Public License for more details.
*
*   You should have received a copy of the GNU Lesser General Public License
*   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
******************************************************************************/

#ifndef _COLOR_QUANTIZER_H
#define _COLOR_QUANTIZER_H

#define __STDC_LIMIT_MACROS
#include <stdint.h>
#include <vector>
#include <boost/concept_check.hpp>
#define HSIZE INT16_MAX
#define MAXCOLORS 256
#define RGB(r,g,b) (word)(((b)&~7)<<7)|(((g)&~7)<<2)|((r)>>3)
#define RED(x)     (byte)(((x)&31)<<3)
#define GREEN(x)   (byte)((((x)>>5)&255)<< 3)
#define BLUE(x)    (byte)((((x)>>10)&255)<< 3)


namespace pdal 
{
namespace drivers
{
namespace prc
{
    
typedef unsigned char byte;
typedef uint16_t word;
typedef struct {
  word lower;
  word upper;
  long     count;
  int      level;
  
  byte     rmin, rmax;
  byte     gmin, gmax;
  byte     bmin, bmax;
} cube_t;

class ColorQuantizer
{
private:
  std::vector<word> histVec;
  cube_t cubeList[MAXCOLORS];
  int longdim;
  
  //int compare(word a1, word a2);
  void shrink(cube_t * cube);
  void invMap(word *  hist, byte colMap[][3], word ncubes);
  
public: 
  ColorQuantizer();
  word medianCut(word hist[], byte ColMap[][3], int maxcubes);
};
}}} //namespace pdal::drivers::prc
#endif //_COLOR_QUANTIZER_H