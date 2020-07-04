attribute vec3 position;
attribute vec3 normal;
attribute vec2 uv;

uniform mat4 localToWorld;
uniform mat4 worldToView;
uniform mat4 viewToScreen;

uniform sampler2D displacementMap;
uniform float displacementScale;

varying vec3 v_viewSurfacePosition;
varying vec3 v_viewSurfaceNormal;
varying vec2 v_uv0;

void main() {

  v_viewSurfaceNormal = normalize( ( worldToView * localToWorld * vec4( normal, 0. ) ).xyz );
  v_viewSurfacePosition = ( worldToView * localToWorld * vec4( position, 1. ) ).xyz;
  v_viewSurfacePosition += v_viewSurfaceNormal * texture2D( displacementMap, vec2(1.0)- uv ).x * displacementScale;

  v_uv0 = uv;
  gl_Position = viewToScreen * vec4( v_viewSurfacePosition, 1. );

}
