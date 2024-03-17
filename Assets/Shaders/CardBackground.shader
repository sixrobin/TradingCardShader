Shader "Card Background"
{
    Properties
    {
        [Header(STENCIL)]
        [Space(5)]
        _StencilRef ("Stencil Ref", Int) = 0
        _StencilComp ("Stencil Comp", Int) = 0
        _StencilPass ("Stencil Pass", Int) = 0
        
        [Header(CULL)]
        [Space(5)]
        _Cull ("Cull", Int) = 0
        
        [Header(COLOR)]
        [Space(5)]
        _Gradient ("Gradient", 2D) = "black" {}
        _BrushOffset ("Brush Offset", Float) = 0
        _BrushIntensity ("Brush Intensity", Float) = 0.5
        
        [PerRendererData] [HideInInspector] _MainTex ("Texture", 2D) = "white" {}
    }
    
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="TransparentCutout"
        }
        
        Stencil
        {
            Ref [_StencilRef]
            Comp [_StencilComp]
            Pass [_StencilPass]
        }
        
        Blend SrcAlpha OneMinusSrcAlpha
        Cull [_Cull]
        ZWrite Off

        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
                float3 color  : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv     : TEXCOORD0;
                float3 color  : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Gradient;
            float _BrushOffset;
            float _BrushIntensity;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 worldScale = float3
                (
                    length(unity_ObjectToWorld._m00_m10_m20),
                    length(unity_ObjectToWorld._m01_m11_m21),
                    length(unity_ObjectToWorld._m02_m12_m22)
                );

                float2 uv = i.uv * worldScale.xy;
                
                float brush = tex2D(_MainTex, uv).r;
                brush = brush * _BrushIntensity + _BrushOffset;

                float4 gradientValue = tex2D(_Gradient, float2(uv.y + brush, 0));
                return gradientValue;
            }
            
            ENDCG
        }
    }
}
