using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplacementToonLighting : MonoBehaviour
{
    public Shader ReplacementShader;

    [Header("Shadows")]
    public Color ShadowColor = Color.black;
    [Range(1, 16)]
    public int ShadowSteps = 5;
    [Range(0.05f, 1)]
    public float ShadowSize = 0.25f;

    [Header("Specular")]
    public Color SpecularColor = Color.white;
    [Range(0, 1)]
    public float SpecularSize = 0.1f;
    [Range(0, 2)]
    public float SpecularFalloff = 1;

    private void OnValidate()
    {
        Shader.SetGlobalColor("_ShadowTint", ShadowColor);
        Shader.SetGlobalInt("_StepAmount", ShadowSteps);
        Shader.SetGlobalFloat("_StepWidth", ShadowSize);
        
        Shader.SetGlobalColor("_SpecularColor", SpecularColor);
        Shader.SetGlobalFloat("_SpecularSize", SpecularSize);
        Shader.SetGlobalFloat("_SpecularFalloff", SpecularFalloff);
    }

    private void OnEnable()
    {
        if (ReplacementShader)
            GetComponent<Camera>().SetReplacementShader(ReplacementShader, "RenderType");
    }

    private void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }
}
