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
/// \file HapticForceEffect.h
/// \brief Header file for HapticForceEffect
///
//
//////////////////////////////////////////////////////////////////////////////
#ifndef __HAPTICFORCEEFFECT_H__
#define __HAPTICFORCEEFFECT_H__

#include <HAPIHapticObject.h> 
#include <RefCountedClass.h>
#include <TimeStamp.h>

namespace HAPI {

  /// The base class for force effects. A HapticForceEffect is a class that 
  /// generates force and torque based on the position and orientation 
  /// of the haptics device (and possibly velocity). It is good to use
  /// to create global effects such as force fields. This class works in
  /// the realtime loop and has to be added in the traversal of the 
  /// scenegraph (traverseSG()) to the TraverseInfo structure in order
  /// to be rendered. By setting the HapticForceEffect to be interpolated
  /// the HapticForceEffect will be interpolated with the HapticForceEffect
  /// added in the last scenegraph loop in order to avoid haptic rendering 
  /// artifacts.
  ///
  class HAPI_API HapticForceEffect: public HAPIHapticObject, 
                                    public H3DUtil::RefCountedClass {
  public:
    /// The input to a HapticForceEffect. 
    struct HAPI_API EffectInput {
      /// Constructor.
      EffectInput( const Vec3 &pos = Vec3( 0,0,0 ),
                   const Vec3 &vel = Vec3( 0,0,0 ),
                   const Rotation &orn = Rotation(),
                   const TimeStamp &dt = 0 ) :
        position( pos ),
        velocity( vel ),
        orientation( orn ),
        deltaT( dt ) {}
      
      /// The position of the finger.
      Vec3 position;
      /// The velocity of the finger.
      Vec3 velocity;
      /// The orientation of the stylus.
      Rotation orientation;
      /// The change in time since the last call
      TimeStamp deltaT;
    };

    /// The output from a HapticForceEffect.
    struct HAPI_API EffectOutput {
      /// Constructor.
      EffectOutput( const Vec3 _force = Vec3( 0,0,0 ),
                    const Vec3 _torque = Vec3( 0,0,0 ) ) :
        force( _force ),
        torque( _torque ) {}
      
      /// The force to render.
      Vec3 force;
      /// The torque to render.
      Vec3 torque;
      
      /// Addition operator. Adds the forces and torques of the
      /// two EffectOutput instances.
      EffectOutput operator +( const EffectOutput &o ) {
        return EffectOutput( force + o.force,
                             torque + o.torque );
      }

      /// Multiplication by float operator. Scales the forces and
      /// torque.
      EffectOutput operator *( float f ) {
        return EffectOutput( force * f,
                             torque *f );
      }

      /// Multiplication by double operator. Scales the forces and
      /// torque.
      EffectOutput operator *( double f ) {
        return EffectOutput( force * f,
                             torque *f );
      }
    };
    
    /// Constructor.
    HapticForceEffect( const Matrix4 & _transform,
                       bool _interpolate ):
      HAPIHapticObject( _transform ),
      interpolate( _interpolate ){}
    
    /// The function that calculates the forces given by this 
    /// HapticForceEffect.
    EffectOutput virtual calculateForces( const EffectInput &input ) {
      return EffectOutput();
    }
    
    /// Destructor. Virtual to make HapticForceEffect a polymorphic type.
    virtual ~HapticForceEffect() {}

    /// Returns if the HapticForceEffect should be interpolated or not.
    bool isInterpolated() {
      return interpolate;
    }

  protected:
    bool interpolate;
  };
}

#endif
