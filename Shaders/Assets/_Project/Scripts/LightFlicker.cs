using UnityEngine;
using System.Collections;

public class LightFlicker : MonoBehaviour
{
    Light currentLight;
    public float minIntensity = 2f;
    public float maxIntensity = 4f;

    float random;

    void Start()
    {
        currentLight = GetComponent<Light>();
        random = Random.Range(0.0f, 65535.0f);
    }

    void Update()
    {
        float noise = Mathf.PerlinNoise(random, Time.time * 3);
        currentLight.intensity = Mathf.Lerp(minIntensity, maxIntensity, noise);
    }
}

