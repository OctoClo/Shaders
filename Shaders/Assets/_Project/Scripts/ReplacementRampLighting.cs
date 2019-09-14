using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplacementRampLighting : MonoBehaviour
{
    public Shader ReplacementShader;
    public Texture RampTexture;

    private void OnValidate()
    {
        Shader.SetGlobalTexture("_Ramp", RampTexture);
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
