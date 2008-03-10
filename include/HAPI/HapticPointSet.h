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
/// \file HapticPointSet.h
/// \brief Header file for HapticPointSet
///
//
//////////////////////////////////////////////////////////////////////////////
#ifndef __HAPTICPOINTSET_H__
#define __HAPTICPOINTSET_H__

#include <HAPI/HAPIHapticShape.h>

namespace HAPI {

  /// A shape defined by a set of points.
  class HAPI_API HapticPointSet: public HAPIHapticShape {
  public:
    /// Constructor.
    HapticPointSet( const vector< Collision::Point > &_points,
                    HAPISurfaceObject *_surface, 
                    Collision::FaceType _touchable_face = 
                    Collision::FRONT_AND_BACK,
                    void *_userdata = NULL,
                    int _shape_id = -1, 
                    void (*_clean_up_func)( void * ) = 0
                    ):
      HAPIHapticShape( _surface, _touchable_face, _userdata,
                       _shape_id, _clean_up_func ),
      points( _points ) {}

    /// Constructor.
    HapticPointSet( const Matrix4 &_transform,
                    const vector< Collision::Point > &_points,
                    HAPISurfaceObject *_surface, 
                    Collision::FaceType _touchable_face = 
                    Collision::FRONT_AND_BACK,
                    void *_userdata = NULL,
                    int _shape_id = -1, 
                    void (*_clean_up_func)( void * ) = 0
                    ):
      HAPIHapticShape( _transform, _surface, _touchable_face, _userdata,
                       _shape_id, _clean_up_func ),
      points( _points ) {}
    
    /// Constructor.
    template< class Iterator >
    HapticPointSet( Iterator begin,
                    Iterator end,
                      const vector< Collision::Point > &_points,
                    HAPISurfaceObject *_surface, 
                    Collision::FaceType _touchable_face = 
                    Collision::FRONT_AND_BACK,
                    void *_userdata = NULL,
                    int _shape_id = -1, 
                    void (*_clean_up_func)( void * ) = 0
                    ):
      HAPIHapticShape( _surface, _touchable_face, _userdata,
                       _shape_id, _clean_up_func ),
      points( begin, end ) {}

    /// Returns the number of points in the point set.
    inline virtual int nrPoints() {
      return points.size();
    }

  protected:
    /// Detect collision between a line segment and the object.
    /// \param from The start of the line segment(in local coords).
    /// \param to The end of the line segment(in local coords).
    /// \param result Contains info about closest intersection, if 
    /// line intersects object(in local coords).
    /// \param face The sides of the object that can be intersected. E.g.
    /// if FRONT, intersections will be reported only if they occur from
    /// the front side, i.e. the side in which the normal points. 
    /// \returns true if intersected, false otherwise.
    virtual bool lineIntersectShape( const Vec3 &from, 
                                     const Vec3 &to,
                                     Collision::IntersectionInfo &result,
                                     Collision::FaceType face = 
                                     Collision::FRONT_AND_BACK  );

    /// Get constraint planes of the shape. A proxy of a haptics renderer
    /// will always stay above any constraints added.
    ///
    /// \param point Point to constrain(in local coords).
    /// \param constraints Where to add the constraints.
    /// \param face Determines which faces of the shape will be seen as
    /// constraining.
    /// \param radius Only add constraints within this radius. If set to -1
    /// all constraints will be added.
    virtual void getConstraintsOfShape( const Vec3 &point,
                                        Constraints &constraints,
                                        Collision::FaceType face = 
                                        Collision::FRONT_AND_BACK,
                                        HAPIFloat radius = -1 );

    /// Get the closest point and normal on the object to the given point p.
    /// \param p The point to find the closest point to(in local coords).
    /// \param closest_point Return parameter for closest point
    /// (in local coords)
    /// \param normal Return parameter for normal at closest point
    /// (in local coords).
    /// \param tex_coord Return paramater for texture coordinate at closest 
    /// point.
    virtual void closestPointOnShape( const Vec3 &p, Vec3 &cp, 
                                      Vec3 &n, Vec3 &tc );

#ifdef HAVE_OPENGL
    /// Render a graphical representation of the shape using OpenGL. This
    /// is used by the OpenHapticsRenderer when using feedback or depth
    /// buffer shapes. 
    virtual void glRenderShape();
#endif

    /// Detect collision between a moving sphere and the object.
    /// \param radius The radius of the sphere(in local coords).
    /// \param from The start position of the sphere(in local coords).
    /// \param to The end position of the sphere(in local coords).
    /// \returns true if intersected, false otherwise.
    virtual bool movingSphereIntersectShape( HAPIFloat radius,
                                             const Vec3 &from, 
                                             const Vec3 &to );

    /// Calculates a matrix transforming a vector from local space of the shape
    /// to texture space of the shape.
    /// \param point The point at which to find the tangent vectors
    /// in local coordinates
    /// \param result_mtx Stores the calculated matrix
    virtual void getTangentSpaceMatrixShape( const Vec3 &point,
                                             Matrix4 &result_mtx );

    /// The points.
    vector< Collision::Point > points;
      
  };
}

#endif
