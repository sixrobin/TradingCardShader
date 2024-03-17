Shader "Robe"
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
        
        [Header(WIND)]
        [Space(5)]
        _WindNoise ("Wind Noise", 2D) = "black" {}
        _WindIntensity ("Wind Intensity", Float) = 1
        _WindMaskMin ("Wind Mask Min", Range(0, 1)) = 0
        _WindMaskMax ("Wind Mask Max", Range(0, 1)) = 1
        
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

            sampler2D _WindNoise;
            float4 _WindNoise_ST;
            float _WindIntensity;
            float _WindMaskMin;
            float _WindMaskMax;

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
                float2 uv = i.uv;
                float wind = tex2D(_WindNoise, uv * _WindNoise_ST.xy + _WindNoise_ST.zw * _Time.y);
                wind = (wind - 0.5) * 2 * _WindIntensity;
                uv += wind * _WindIntensity * smoothstep(_WindMaskMin, _WindMaskMax, 1 - i.uv.y);
                
                float4 color = tex2D(_MainTex, uv);
                color.rgb *= i.color;
                return color;
            }
            
            ENDCG
        }
    }
}
