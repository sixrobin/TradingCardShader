namespace RSLib
{
    using UnityEngine;

    [DisallowMultipleComponent]
    public class Rotator : MonoBehaviour
    {
        [SerializeField, Range(0f, 360f)]
        private float _rotationSpeed = 90f;
        [SerializeField]
        private bool _clockwise = true;
        [SerializeField]
        private Axis _axis = Axis.Z;
        [SerializeField]
        private Space _space = Space.Self;

        private Quaternion _initRotation;
        
        public enum Axis
        {
            [InspectorName("None")] NONE,
            X,
            Y,
            Z
        }

        #if ODIN_INSPECTOR
        [Sirenix.OdinInspector.ButtonAttribute]
        #endif
        private void ResetRotation()
        {
            transform.rotation = _initRotation;
        }
        
        private void Start()
        {
            _initRotation = transform.rotation;
        }

        private void Update()
        {
            if (_axis == Axis.NONE)
                return;
            
            float speed = _rotationSpeed * Time.deltaTime;
            if (_clockwise)
                speed = -speed;

            Vector3 rotation = _axis switch
            {
                Axis.X => new Vector3(speed, 0f, 0f),
                Axis.Y => new Vector3(0f, speed, 0f),
                Axis.Z => new Vector3(0f, 0f, speed),
                _ => Vector3.zero
            };

            transform.Rotate(rotation, _space);
        }
    }
}
