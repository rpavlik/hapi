//////////////////////////////////////////////////////////////////////////////
//    Copyright 2004, SenseGraphics AB
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
/// \file HapticTriangle.h
/// \brief Header file for HapticTriangle
///
//
//////////////////////////////////////////////////////////////////////////////
#ifndef __HAPTICTRIANGLE_H__
#define __HAPTICTRIANGLE_H__

#include <HAPIHapticShape.h>

namespace H3D {

  /// Base class for haptic shapes, i.e. geometrical objects that are rendered
  /// by letting their surfaces constrain the proxy. A HapticShape has a Surface
  /// object associated to it that defines the properties of the surface, e.g.
  /// stiffness and friction properties.
  ///
  class HAPI_API HapticTriangle: public HAPIHapticShape {
  public:
    /// Constructor.
    HapticTriangle( const Bounds::Triangle &_triangle,
                    void *_userdata,
                    HAPISurfaceObject *_surface,
                    const H3D::ArithmeticTypes::Matrix4d & _transform ):
      HAPIHapticShape( _userdata, _surface, _transform ),
      triangle( _triangle ) {}
    
      /// Returns the closest point on the object to the given point p.
    inline virtual Vec3d closestPoint( const Vec3d &p ) {
      return triangle.closestPoint( p );
    }

    /// Detect collision between a line segment and the object.
    /// \param from The start of the line segment.
    /// \param to The end of the line segment.
    /// \param result Contains info about the closest intersection, if 
    /// line intersects object
    /// \returns true if intersected, false otherwise.
    inline virtual bool lineIntersect( const Vec3d &from, 
                                       const Vec3d &to,
                                       Bounds::IntersectionInfo &result ) {
      return triangle.lineIntersect( from, to, result );
    }

    inline virtual void getConstraints( const Vec3d &point,
                                        H3DDouble radius,
                                        std::vector< PlaneConstraint > &constraints ) {
      Vec3d p = transform.inverse() * point;
      unsigned int size = constraints.size();
      triangle.getConstraints( p, radius, constraints);
      for( unsigned int i = size; i < constraints.size(); i ++ ) {
        PlaneConstraint &pc = constraints[i];
        pc.point = transform * pc.point;
        pc.normal = transform.getRotationPart() * pc.normal;
      }
    }

  protected:
    Bounds::Triangle triangle; 
  };
}

#endif
