using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplacementOverDraw : MonoBehaviour
{
    public Shader OverDrawShader;
    public Color OverDrawColor = Color.white;

    private void OnValidate()
    {
        Shader.SetGlobalColor("_OverDrawColor", OverDrawColor);
    }

    private void OnEnable()
    {
        if (OverDrawShader)
            GetComponent<Camera>().SetReplacementShader(OverDrawShader, "");
    }

    private void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }
}
