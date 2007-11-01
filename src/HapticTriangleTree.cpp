//////////////////////////////////////////////////////////////////////////////
//    Copyright 2004-2007, SenseGraphics AB
//
//    This file is part of H3D API.
//
//    H3D API is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation; either version 2 of the License, or
//    (at your option) any later version.
//
//    H3D API is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with H3D API; if not, write to the Free Software
//    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
//    A commercial license is also available. Please contact us at 
//    www.sensegraphics.com for more information.
//
//
/// \file HapticTriangleTree.cpp
/// \brief cpp file for HapticTriangleTree
///
//
//////////////////////////////////////////////////////////////////////////////

#include <HAPI/HapticTriangleTree.h>
#include <HAPI/PlaneConstraint.h>

using namespace HAPI;


bool HapticTriangleTree::lineIntersectShape( const Vec3 &from, 
                                          const Vec3 &to,
                                          Collision::IntersectionInfo &result,
                                          Collision::FaceType face ) {
  return tree->lineIntersect( from, to, result, face );
}

void HapticTriangleTree::closestPointOnShape( const Vec3 &p, Vec3 &cp, 
                                           Vec3 &n, Vec3 &tc ) {
  tree->closestPoint( p, cp, n, tc );
}

bool HapticTriangleTree::movingSphereIntersectShape( HAPIFloat radius,
                                                  const Vec3 &from, 
                                                  const Vec3 &to ) {
  return tree->movingSphereIntersect( radius, from, to );
}

void HapticTriangleTree::getConstraintsOfShape( const Vec3 &point,
                                             Constraints &constraints,
                                             Collision::FaceType face,
                                             HAPIFloat radius ) {
  unsigned int size = constraints.size();
  tree->getConstraints( point, constraints, face, radius );
  for( unsigned int i = size; i < constraints.size(); ++i ) {
    PlaneConstraint &pc = constraints[i];
    pc.haptic_shape.reset(this);
  }
}

void HapticTriangleTree::glRenderShape() {
// TODO: fix 
//  return tree->render();
}

void HapticTriangleTree::getTangentSpaceMatrix( const Vec3 &point,
                                                Matrix4 &result_mtx ) {
  vector< Collision::Triangle > triangles;
  vector< Collision::LineSegment > lines;
  vector< Collision::Point > points;
  tree->getPrimitivesWithinRadius( point, Constants::epsilon * 10, triangles, lines, points );
  if( !triangles.empty() ) {
    Vec3 local_point = point;
    if( have_transform )
      local_point = getInverse() * point;
    if( triangles.size() == 1 ) {
      triangles[0].getTangentSpaceMatrix( local_point, result_mtx );
    } else {
      Vec3 temp_cp, temp_n;
      int closest_primitive = -1;
      HAPIFloat distance, temp_distance;
      for( unsigned int i = 0; i < triangles.size(); i++ ) {
        triangles[i].closestPoint( local_point, temp_cp, temp_n, temp_n );
        if( i == 0 ) {
          distance = ( temp_cp - local_point).lengthSqr();
          closest_primitive = i;
        }
        else {
          temp_distance = (temp_cp - local_point).lengthSqr();
          if( temp_distance < distance ) {
            closest_primitive = i;
            distance = temp_distance;
          }
        }
      }

      if( closest_primitive != -1 ) {
        triangles[closest_primitive].
          getTangentSpaceMatrix( local_point, result_mtx );
      }
    }

    if( have_transform )
      result_mtx = result_mtx * getInverse();
  }
}
