using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TurnAroundScript : MonoBehaviour
{
    public float turnSpeed = 20f;

    void LateUpdate()
    {
        transform.Rotate(0, Time.deltaTime * turnSpeed, 0);
    }
}
