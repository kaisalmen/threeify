precision highp float;

varying vec3 v_viewSurfacePosition;
varying vec3 v_viewSurfaceNormal;
varying vec2 v_uv0;

uniform vec3 pointLightViewPosition;
uniform vec3 pointLightColor;
uniform float pointLightRange;

uniform vec3 albedoModulator;
uniform sampler2D albedoMap;

#pragma include <brdfs/diffuse/lambert.glsl>
#pragma include <brdfs/common.glsl>
#pragma include <lighting/punctual.glsl>

void main() {

  vec3 albedo = albedoModulator * texture2D( albedoMap, v_uv0 ).rgb;

  PunctualLight punctualLight;
  punctualLight.type = LightType_Point;
  punctualLight.position = pointLightViewPosition;
  punctualLight.color = pointLightColor;
  punctualLight.direction = vec3(0.0);
  punctualLight.range = pointLightRange;
  punctualLight.innerConeCos = 0.0;
  punctualLight.outerConeCos = 0.0;

  Surface surface;
  surface.position = v_viewSurfacePosition;
  surface.normal = v_viewSurfaceNormal;

  DirectIllumination directIllumination;
  pointLightToDirectIllumination( surface, punctualLight, directIllumination );

  float dotNL = clamp( dot( -directIllumination.incidentDirection, surface.normal ), 0.0, 1.0 );

  gl_FragColor.rgb = dotNL * directIllumination.color * BRDF_Diffuse_Lambert( albedo );
  gl_FragColor.rgb = pow( gl_FragColor.rgb, vec3( 0.5 ) );
  gl_FragColor.a = 1.0;

}
