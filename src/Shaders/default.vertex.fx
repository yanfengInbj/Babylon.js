﻿layout(std140, column_major) uniform;

uniform Material
{
	
	vec4 diffuseLeftColor;
	vec4 diffuseRightColor;
	vec4 opacityParts;
	vec4 reflectionLeftColor;
	vec4 reflectionRightColor;
	vec4 refractionLeftColor;
	vec4 refractionRightColor;
	vec4 emissiveLeftColor;
	vec4 emissiveRightColor;
	vec2 vDiffuseInfos;
	vec2 vAmbientInfos;
	vec2 vOpacityInfos;
	vec2 vReflectionInfos;
	vec2 vEmissiveInfos;
	vec2 vLightmapInfos;
	vec2 vSpecularInfos;
	vec3 vBumpInfos;
	mat4 diffuseMatrix;
	mat4 ambientMatrix;
	mat4 opacityMatrix;
	mat4 reflectionMatrix;
	mat4 emissiveMatrix;
	mat4 lightmapMatrix;
	mat4 specularMatrix;
	mat4 bumpMatrix;
	mat4 refractionMatrix;
	vec4 vRefractionInfos;
	vec4 vSpecularColor;
	vec3 vEmissiveColor;
	vec4 vDiffuseColor;
	float pointSize;
} uMaterial;

uniform mat4 viewProjection;
uniform Scene {
	mat4 viewProjection;
} uScene;

// Attributes
attribute vec3 position;
#ifdef NORMAL
attribute vec3 normal;
#endif
#ifdef TANGENT
attribute vec4 tangent;
#endif
#ifdef UV1
attribute vec2 uv;
#endif
#ifdef UV2
attribute vec2 uv2;
#endif
#ifdef VERTEXCOLOR
attribute vec4 color;
#endif

#include<bonesDeclaration>

// Uniforms
#include<instancesDeclaration>

uniform mat4 view;

#ifdef DIFFUSE
varying vec2 vDiffuseUV;
#endif

#ifdef AMBIENT
varying vec2 vAmbientUV;
#endif

#ifdef OPACITY
varying vec2 vOpacityUV;
#endif

#ifdef EMISSIVE
varying vec2 vEmissiveUV;
#endif

#ifdef LIGHTMAP
varying vec2 vLightmapUV;
#endif

#if defined(SPECULAR) && defined(SPECULARTERM)
varying vec2 vSpecularUV;
#endif

#ifdef BUMP
varying vec2 vBumpUV;
#endif

#include<pointCloudVertexDeclaration>

// Output
varying vec3 vPositionW;
#ifdef NORMAL
varying vec3 vNormalW;
#endif

#ifdef VERTEXCOLOR
varying vec4 vColor;
#endif

#include<bumpVertexDeclaration>

#include<clipPlaneVertexDeclaration>

#include<fogVertexDeclaration>
#include<shadowsVertexDeclaration>[0..maxSimultaneousLights]

#ifdef REFLECTIONMAP_SKYBOX
varying vec3 vPositionUVW;
#endif

#if defined(REFLECTIONMAP_EQUIRECTANGULAR_FIXED) || defined(REFLECTIONMAP_MIRROREDEQUIRECTANGULAR_FIXED)
varying vec3 vDirectionW;
#endif

#include<logDepthDeclaration>

void main(void) {
#ifdef REFLECTIONMAP_SKYBOX
	vPositionUVW = position;
#endif 

#include<instancesVertex>
#include<bonesVertex>

	gl_Position = uScene.viewProjection * finalWorld * vec4(position, 1.0);

	vec4 worldPos = finalWorld * vec4(position, 1.0);
	vPositionW = vec3(worldPos);

#ifdef NORMAL
	vNormalW = normalize(vec3(finalWorld * vec4(normal, 0.0)));
#endif

#if defined(REFLECTIONMAP_EQUIRECTANGULAR_FIXED) || defined(REFLECTIONMAP_MIRROREDEQUIRECTANGULAR_FIXED)
	vDirectionW = normalize(vec3(finalWorld * vec4(position, 0.0)));
#endif

	// Texture coordinates
#ifndef UV1
	vec2 uv = vec2(0., 0.);
#endif
#ifndef UV2
	vec2 uv2 = vec2(0., 0.);
#endif

#ifdef DIFFUSE
	if (uMaterial.vDiffuseInfos.x == 0.)
	{
		vDiffuseUV = vec2(uMaterial.diffuseMatrix * vec4(uv, 1.0, 0.0));
	}
	else
	{
		vDiffuseUV = vec2(uMaterial.diffuseMatrix * vec4(uv2, 1.0, 0.0));
	}
#endif

#ifdef AMBIENT
	if (uMaterial.vAmbientInfos.x == 0.)
	{
		vAmbientUV = vec2(uMaterial.ambientMatrix * vec4(uv, 1.0, 0.0));
	}
	else
	{
		vAmbientUV = vec2(uMaterial.ambientMatrix * vec4(uv2, 1.0, 0.0));
	}
#endif

#ifdef OPACITY
	if (uMaterial.vOpacityInfos.x == 0.)
	{
		vOpacityUV = vec2(uMaterial.opacityMatrix * vec4(uv, 1.0, 0.0));
	}
	else
	{
		vOpacityUV = vec2(uMaterial.opacityMatrix * vec4(uv2, 1.0, 0.0));
	}
#endif

#ifdef EMISSIVE
	if (uMaterial.vEmissiveInfos.x == 0.)
	{
		vEmissiveUV = vec2(uMaterial.emissiveMatrix * vec4(uv, 1.0, 0.0));
	}
	else
	{
		vEmissiveUV = vec2(uMaterial.emissiveMatrix * vec4(uv2, 1.0, 0.0));
	}
#endif

#ifdef LIGHTMAP
	if (uMaterial.vLightmapInfos.x == 0.)
	{
		vLightmapUV = vec2(uMaterial.lightmapMatrix * vec4(uv, 1.0, 0.0));
	}
	else
	{
		vLightmapUV = vec2(uMaterial.lightmapMatrix * vec4(uv2, 1.0, 0.0));
	}
#endif

#if defined(SPECULAR) && defined(SPECULARTERM)
	if (uMaterial.vSpecularInfos.x == 0.)
	{
		vSpecularUV = vec2(uMaterial.specularMatrix * vec4(uv, 1.0, 0.0));
	}
	else
	{
		vSpecularUV = vec2(uMaterial.specularMatrix * vec4(uv2, 1.0, 0.0));
	}
#endif

#ifdef BUMP
	if (uMaterial.vBumpInfos.x == 0.)
	{
		vBumpUV = vec2(uMaterial.bumpMatrix * vec4(uv, 1.0, 0.0));
	}
	else
	{
		vBumpUV = vec2(uMaterial.bumpMatrix * vec4(uv2, 1.0, 0.0));
	}
#endif

#include<bumpVertex>
#include<clipPlaneVertex>
#include<fogVertex>
#include<shadowsVertex>[0..maxSimultaneousLights]

#ifdef VERTEXCOLOR
	// Vertex color
	vColor = color;
#endif

#include<pointCloudVertex>
#include<logDepthVertex>

}