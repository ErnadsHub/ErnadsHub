return (function(...) hercules,v1,alpha,__,_='Protected By Hercules V1.6 | VM',function()end,true,1,0 local LuaFunc,WrapState,BcToState,gChunk;local FIELDS_PER_FLUSH=50 local Select=select;local function CreateTbl(_)return{}end;local Unpack=unpack or table.unpack local function Pack(...)return{n=Select('#',...),...}end local function Move(src,First,Last,Offset,Dst)for i=_,Last - First do Dst[Offset+i]=src[First+i]end end local function BAnd(a,b)local result=_ local bitval=__ while a>_ and b>_ do if(a % 2==__)and(b % 2==__)then result=result+bitval end bitval=bitval*2 a=math.floor(a/2)b=math.floor(b/2)end return result end local function LShift(x,n)return x*2^n end local function RShift(x,n)return math.floor(x/2^n)end local function BOr(a,b)local result=_ local shift=__ while a>_ or b>_ do local abit=a % 2 local bbit=b % 2 if abit==__ or bbit==__ then result=result+shift end a=math.floor(a/2)b=math.floor(b/2)shift=shift*2 end return result end local function CloseLuaUpvalues(B,N)for i,uv in pairs(B)do if uv.N>=N then uv.m=uv.M[uv.N];uv.M=uv;uv.N='m'B[i]=nil;end;end;end;local function SenLuaUpvalue(B,N,X)local Prev=B[N]if not Prev then Prev={N=N,M=X}B[N]=Prev;end;return Prev;end;function BcToState(Bytecode,charset)local base,decoded=#charset,{}local decode_lookup={}for i=1,base do decode_lookup[charset:sub(i,i)]=i - 1 end for encoded_char in Bytecode:gmatch("[^x]+")do local n=0 for i=1,#encoded_char do n=n*base+decode_lookup[encoded_char:sub(i,i)]end decoded[#decoded+1]=string.char(n)end Bytecode=table.concat(decoded)local Pos=__ local function gBits8()local Val=string.byte(Bytecode,Pos,Pos)Pos=Pos+__ return Val;end;local function gBits16()local Val1,Val2=string.byte(Bytecode,Pos,Pos+2)Pos=Pos+2;return(Val2*256)+Val1;end;local function gBits32()local Val1,Val2,Val3,Val4=string.byte(Bytecode,Pos,Pos+3)Pos=Pos+4;return(Val4*16777216)+(Val3*65536)+(Val2*256)+Val1;end;function gChunk()local Chunk={n=gBits8(),c=gBits8(),d=gBits8(),x={},D={},V={}}for i=__,gBits32()do local Data=gBits32()local Sco=gBits8()local Type=gBits8()local Inst={m=Data,S=Sco,A=gBits16()}local Mode={b=gBits8(),c=gBits8()}if(Type==__)then Inst.B=gBits16()Inst.C=gBits16()Inst.s=Mode.b==__ and Inst.B>0xFF Inst.a=Mode.c==__ and Inst.C>0xFF elseif(Type==2)then Inst.F=gBits32()Inst.g=Mode.b==__ elseif(Type==3)then Inst.f=gBits32()- 131071 end;Chunk.x[i]=Inst;end;for i=__,gBits32()do local Type=gBits8()if(Type==__)then Chunk.D[i - __]=(gBits8()~=_)elseif(Type==3)then Chunk.D[i - __]=(function()local Left=gBits32()local Right=gBits32()local IsNormal=__ local Mantissa=BOr(LShift(BAnd(Right,0xFFFFF),32),Left);local Exponent=BAnd(RShift(Right,20),0x7FF)local Sign=(-__)^RShift(Right,31)if Exponent==_ then if Mantissa==_ then return Sign*_ else Exponent=__ IsNormal=_ end;elseif Exponent==2047 then if Mantissa==_ then return Sign*(__/_)else return Sign*(_/_)end;end;return math.ldexp(Sign,Exponent - 1023)*(IsNormal+(Mantissa/(2^52)))end)()elseif(Type==4)then Chunk.D[i - __]=(function()local Str;local baik=gBits32();if(baik==_)then return;end;Str=string.sub(Bytecode,Pos,Pos+baik - __);Pos=Pos+baik return Str;end)()end end;for i=__,gBits32()do Chunk.V[i - __]=gChunk()end for _,v in ipairs(Chunk.x)do if v.g then v.D=Chunk.D[v.F]else if v.s then v.A=Chunk.D[v.B - 256]end;if v.a then v.C=Chunk.D[v.C - 256]end;end;end return Chunk end;return gChunk()end;function LuaFunc(State,Env,n)local x=State.x;local V=State.Z;local v=State.v;local Top=-__;local SenB={}local X=State.X;local z=State.z;while alpha do local Inst=x[z]local S=Inst.S;z=z+__;if(S==1)then X[Inst.A]=Inst.D elseif(S==2)then X[Inst.A]=Inst.B~=0 if Inst.C~=0 then z=z+1 end;elseif(S==4)then local Uv=n[Inst.B]X[Inst.A]=Uv.M[Uv.N]elseif(S==5)then X[Inst.A]=Env[Inst.D]elseif(S==6)then local N if Inst.a then N=Inst.C;else N=X[Inst.C]end X[Inst.A]=X[Inst.B][N]elseif(S==0)then X[Inst.A]=X[Inst.B];elseif(S==22)then z=z+Inst.f elseif(S==23)then local Lhs,Rhs;if Inst.s then Lhs=Inst.A else Lhs=X[Inst.B]end if Inst.a then Rhs=Inst.C else Rhs=X[Inst.C]end if(Lhs==Rhs)==(Inst.A~=0)then z=z+x[z].f end;z=z+1 elseif(S==30)then local A=Inst.A;local B=Inst.B;local b;if B==0 then b=Top - A+1;else b=B - 1;end;CloseLuaUpvalues(SenB,0)return Unpack(X,A,A+b - 1)elseif(S==11)then local A=Inst.A local B=Inst.B local N;if Inst.a then N=Inst.C else N=X[Inst.C]end X[A+1]=X[B]X[A]=X[B][N]elseif(S==26)then if(not X[Inst.A])~=(Inst.C~=0)then z=z+x[z].f end z=z+1 elseif(S==36)then local Sub=V[Inst.F]local Nups=Sub.n;local UvB;if Nups~=0 then UvB=CreateTbl(Nups - 1)for i=1,Nups do local Pseudo=x[z+i - 1]if(Pseudo.S==0)then UvB[i - 1]=SenLuaUpvalue(SenB,Pseudo.B,X)elseif(Pseudo.S==4)then UvB[i - 1]=n[Pseudo.B]end;end;z=z+Nups end;X[Inst.A]=WrapState(Sub,Env,UvB)elseif(S==28)then local A=Inst.A;local B=Inst.B;local C=Inst.C;local Params;if B==0 then Params=Top - A;else Params=B - 1;end;local RetB=Pack(X[A](Unpack(X,A+1,A+Params)))local RetNum=RetB.n;if C==0 then Top=A+RetNum - 1;else RetNum=C - 1;end;Move(RetB,1,RetNum,A,X)end State.z=z;end;end;function WrapState(V,Env,Upval)local function Wrapped(...)local Passed=Pack(...)local X=CreateTbl(V.d)local v={b=_,B={}}Move(Passed,__,V.c,_,X)if(V.c<Passed.n)then local Start=V.c+__ local b=Passed.n - V.c;v.b=b;Move(Passed,Start,Start+b - __,__,v.B)end;local State={v=v,X=X,x=V.x,Z=V.V,z=__}return LuaFunc(State,Env,Upval)end;return Wrapped;end;WrapState(BcToState('\123\120\123\120\93\120\65\120\123\120\123\120\123\120\89\120\123\120\123\120\49\123\120\89\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\49\120\123\120\74\120\123\120\123\120\123\120\74\120\49\120\123\120\123\120\74\120\123\120\123\120\123\120\123\120\123\120\60\120\123\120\123\120\123\120\60\120\49\120\123\120\123\120\123\120\123\120\123\120\123\120\123\120\123\120\74\74\120\74\123\120\123\120\123\120\74\120\49\120\74\120\123\120\74\120\123\120\74\120\123\120\123\120\123\120\49\74\120\49\123\120\123\120\123\120\74\120\49\120\49\120\123\120\74\120\123\120\49\120\123\120\123\120\123\120\46\74\120\46\123\120\123\120\123\120\74\120\49\120\46\120\123\120\74\120\123\120\46\120\123\120\123\120\123\120\74\120\74\120\74\120\123\120\74\120\49\120\57\120\123\120\74\120\123\120\57\120\123\120\123\120\123\120\89\120\123\120\123\120\49\123\120\89\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\49\120\123\120\74\74\120\74\74\120\74\120\123\120\74\120\49\120\73\120\123\120\74\120\123\120\73\120\123\120\123\120\123\120\74\60\120\74\74\120\123\120\123\120\60\120\49\120\73\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\49\74\120\49\74\120\74\120\123\120\74\120\49\120\44\120\123\120\74\120\123\120\44\120\123\120\123\120\123\120\46\74\120\46\74\120\74\120\123\120\74\120\49\120\52\120\123\120\74\120\123\120\52\120\123\120\123\120\123\120\74\120\49\120\49\120\123\120\74\120\49\120\96\120\123\120\74\120\123\120\96\120\123\120\123\120\123\120\89\120\123\120\123\120\49\123\120\89\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\49\120\123\120\74\74\120\74\49\120\49\120\123\120\74\120\49\120\38\120\123\120\74\120\123\120\38\120\123\120\123\120\123\120\74\49\120\49\120\123\120\123\120\49\120\74\120\38\120\123\120\123\120\123\120\123\120\123\120\123\120\123\120\74\37\120\74\49\120\123\120\123\120\37\120\74\120\38\120\123\120\123\120\123\120\123\120\123\120\74\120\123\120\89\120\49\123\120\49\120\49\123\120\89\120\46\120\123\120\123\120\123\120\123\120\88\120\123\120\49\120\123\120\49\73\120\49\49\120\49\120\123\120\73\120\49\120\88\120\123\120\74\120\123\120\88\120\123\120\123\120\123\120\49\44\120\46\49\120\74\49\120\73\120\44\120\74\120\88\120\123\120\123\120\74\120\88\120\123\120\59\120\74\120\46\74\120\49\120\46\120\123\120\74\120\49\120\59\120\123\120\74\120\123\120\58\120\123\120\123\120\123\120\74\120\74\46\120\46\120\123\120\74\120\49\120\58\120\123\120\74\120\123\120\64\120\123\120\123\120\123\120\49\91\120\49\49\120\49\123\120\74\120\91\120\74\120\88\120\123\120\123\120\123\120\46\120\123\120\49\120\123\120\53\120\123\120\74\46\120\73\120\53\120\74\120\123\120\123\120\74\120\74\120\88\120\123\120\58\120\74\120\89\120\74\123\120\123\120\49\123\120\89\120\46\120\123\120\123\120\123\120\123\120\74\120\123\120\49\120\123\120\49\74\120\49\49\120\46\120\123\120\74\120\49\120\88\120\123\120\74\120\123\120\41\120\123\120\123\120\123\120\89\120\123\120\46\65\120\74\83\120\89\120\46\120\123\120\123\120\123\120\123\120\46\78\120\46\83\120\74\120\123\120\74\49\120\49\120\49\123\120\123\120\49\120\74\120\38\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\89\120\49\123\120\46\126\120\74\83\120\89\120\46\120\123\120\123\120\123\120\123\120\46\94\120\46\83\120\74\120\123\120\49\73\120\46\49\120\46\120\123\120\73\120\49\120\88\120\123\120\74\120\123\120\68\120\123\120\123\120\123\120\46\73\120\49\120\57\120\123\120\73\120\49\120\59\120\123\120\74\120\123\120\79\120\123\120\123\120\123\120\46\59\120\74\49\120\46\57\120\73\120\59\120\74\120\59\120\123\120\123\120\74\120\59\120\123\120\35\120\74\120\74\74\120\49\46\120\57\120\123\120\74\120\49\120\64\120\123\120\74\120\123\120\66\120\123\120\123\120\123\120\46\91\120\49\120\49\123\120\74\120\91\120\74\120\59\120\123\120\123\120\123\120\46\120\123\120\123\120\123\120\49\91\120\49\49\120\123\120\123\120\91\120\74\120\88\120\123\120\123\120\123\120\123\120\123\120\49\120\123\120\49\91\120\74\49\120\49\123\120\123\120\91\120\74\120\88\120\123\120\123\120\123\120\74\120\123\120\74\120\123\120\49\74\120\46\49\120\57\120\123\120\74\120\49\120\88\120\123\120\74\120\123\120\84\120\123\120\123\120\123\120\46\74\120\49\120\73\120\123\120\74\120\49\120\59\120\123\120\74\120\123\120\93\120\123\120\123\120\123\120\74\120\74\46\120\73\120\123\120\74\120\49\120\58\120\123\120\74\120\123\120\77\120\123\120\123\120\123\120\60\120\49\46\120\123\120\123\120\60\120\49\120\58\120\123\120\123\120\123\120\49\120\123\120\123\120\123\120\89\120\123\120\123\120\49\123\120\89\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\49\120\123\120\74\74\120\49\46\120\73\120\123\120\74\120\49\120\64\120\123\120\74\120\123\120\89\120\123\120\123\120\123\120\74\60\120\46\46\120\123\120\123\120\60\120\49\120\64\120\123\120\123\120\123\120\46\120\123\120\123\120\123\120\49\74\120\46\46\120\73\120\123\120\74\120\49\120\41\120\123\120\74\120\123\120\53\120\123\120\123\120\123\120\89\120\123\120\123\120\49\123\120\89\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\49\120\123\120\46\74\120\46\120\44\120\123\120\74\120\49\120\68\120\123\120\74\120\123\120\62\120\123\120\123\120\123\120\46\74\120\74\46\120\44\120\123\120\74\120\49\120\68\120\123\120\74\120\123\120\75\120\123\120\123\120\123\120\74\120\49\57\120\44\120\123\120\74\120\49\120\79\120\123\120\74\120\123\120\37\120\123\120\123\120\123\120\74\74\120\46\57\120\44\120\123\120\74\120\49\120\35\120\123\120\74\120\123\120\70\120\123\120\123\120\123\120\74\60\120\57\120\74\120\123\120\60\120\49\120\35\120\123\120\123\120\123\120\57\120\123\120\123\120\123\120\49\74\120\57\120\52\120\123\120\74\120\49\120\66\120\123\120\74\120\123\120\91\120\123\120\123\120\123\120\89\120\49\123\120\74\120\49\123\120\89\120\46\120\123\120\123\120\123\120\123\120\44\120\123\120\49\120\123\120\46\74\120\74\57\120\52\120\123\120\74\120\49\120\84\120\123\120\74\120\123\120\124\120\123\120\123\120\123\120\89\120\123\120\74\120\49\123\120\89\120\46\120\123\120\123\120\123\120\123\120\57\120\123\120\49\120\123\120\89\120\46\123\120\46\67\120\74\83\120\89\120\46\120\123\120\123\120\123\120\123\120\46\61\120\46\83\120\74\120\123\120\89\120\49\123\120\123\120\49\123\120\89\120\46\120\123\120\123\120\123\120\123\120\49\120\123\120\49\120\123\120\46\74\120\49\57\120\52\120\123\120\74\120\49\120\84\120\123\120\74\120\123\120\48\120\123\120\123\120\123\120\89\120\123\120\123\120\49\123\120\89\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\49\120\123\120\46\74\120\46\57\120\52\120\123\120\74\120\49\120\84\120\123\120\74\120\123\120\72\120\123\120\123\120\123\120\46\60\120\74\57\120\74\120\123\120\60\120\49\120\84\120\123\120\123\120\123\120\73\120\123\120\123\120\123\120\48\120\123\120\49\123\120\123\120\48\120\74\120\123\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\85\120\123\120\123\120\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\71\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\49\123\120\74\62\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\49\123\120\74\49\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\78\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\61\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\74\75\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\60\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\46\123\120\74\77\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\74\41\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\49\123\120\74\58\120\74\123\120\57\120\57\120\123\120\123\120\123\120\74\36\120\74\43\120\74\78\120\74\125\120\57\120\44\120\123\120\123\120\123\120\74\94\120\74\43\120\74\95\120\74\60\120\74\63\120\74\36\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\123\120\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\46\90\120\83\120\46\120\123\120\123\120\123\120\123\120\123\120\85\120\74\33\120\74\123\120\57\120\88\120\123\120\123\120\123\120\74\80\120\74\63\120\74\43\120\74\60\120\74\47\120\74\78\120\74\94\120\74\51\120\74\95\120\74\86\120\57\120\57\120\123\120\123\120\123\120\74\86\120\74\43\120\74\36\120\74\50\120\57\120\52\120\123\120\123\120\123\120\74\96\120\74\78\120\74\78\120\74\90\120\74\52\120\74\50\120\74\78\120\57\120\74\85\120\123\120\123\120\123\120\74\125\120\74\78\120\74\78\120\74\90\120\74\47\120\33\120\63\120\63\120\74\94\120\74\43\120\74\56\120\95\120\74\86\120\74\51\120\74\78\120\74\125\120\74\82\120\74\55\120\74\82\120\74\47\120\74\50\120\74\94\120\74\42\120\74\63\120\74\95\120\74\78\120\74\50\120\74\95\120\74\78\120\95\120\74\42\120\74\63\120\74\36\120\63\120\74\36\120\74\82\120\74\51\120\74\81\120\74\69\120\90\120\82\120\63\120\74\94\120\74\43\120\74\95\120\74\60\120\74\63\120\74\36\120\74\50\120\74\60\120\74\51\120\74\78\120\74\50\120\74\60\120\74\47\120\74\42\120\74\94\120\74\51\120\74\90\120\74\78\120\74\47\120\63\120\74\94\120\74\50\120\74\76\120\74\47\120\63\120\74\125\120\74\50\120\74\43\120\74\60\120\74\47\120\63\120\74\36\120\74\43\120\74\51\120\74\95\120\63\120\74\36\120\74\51\120\74\95\120\74\50\120\74\47\120\74\56\120\74\50\120\74\50\120\74\90\120\74\50\120\74\94\120\74\50\120\74\47\120\74\90\120\95\120\74\80\120\74\82\120\74\43\120\46\120\123\120\123\120\123\120\123\120\123\120\49\123\120\74\74\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\49\123\120\74\84\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\93\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\46\123\120\74\89\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\40\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\74\62\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\49\123\120\74\38\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\90\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\74\44\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\74\49\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\67\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\46\123\120\74\53\120\74\123\120\46\120\123\120\123\120\123\120\123\120\123\120\46\123\120\74\35\120\74\123\120\44\120\123\120\123\120\123\120\123\120\74\120\49\120\49\120\123\120\123\120\123\120\74\74\120\123\120\123\120\123\120\74\120\49\120\74\120\123\120\74\120\123\120\123\120\123\120\123\120\123\120\48\120\123\120\49\123\120\123\120\48\120\74\120\123\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\47\120\74\123\120\123\120\123\120\123\120\123\120\123\120\74\120\49\120\49\120\123\120\123\120\123\120\74\74\120\123\120\123\120\123\120\74\120\49\120\74\120\123\120\74\120\123\120\123\120\123\120\123\120\123\120\48\120\123\120\49\123\120\123\120\48\120\74\120\123\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\46\120\123\120\123\120\123\120\123\120\123\120\46\123\120\74\35\120\74\123\120\123\120\123\120\123\120\123\120\123\120\74\120\49\120\49\120\123\120\123\120\123\120\74\74\120\123\120\123\120\123\120\74\120\49\120\74\120\123\120\74\120\123\120\123\120\123\120\123\120\123\120\48\120\123\120\49\123\120\123\120\48\120\74\120\123\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\87\120\74\123\120\123\120\123\120\123\120\123\120\123\120\74\120\49\120\49\120\123\120\123\120\123\120\74\74\120\123\120\123\120\123\120\74\120\49\120\74\120\123\120\74\120\123\120\123\120\123\120\123\120\123\120\48\120\123\120\49\123\120\123\120\48\120\74\120\123\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\74\123\120\74\123\120\123\120\123\120\123\120\123\120\123\120\74\120\49\120\49\120\123\120\123\120\123\120\74\74\120\123\120\123\120\123\120\74\120\49\120\74\120\123\120\74\120\123\120\123\120\123\120\123\120\123\120\48\120\123\120\49\123\120\123\120\48\120\74\120\123\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\46\120\123\120\123\120\123\120\123\120\123\120\46\123\120\74\62\120\74\123\120\123\120\123\120\123\120\123\120\123\120\74\120\49\120\49\120\123\120\123\120\123\120\74\74\120\123\120\123\120\123\120\74\120\49\120\74\120\123\120\74\120\123\120\123\120\123\120\123\120\123\120\48\120\123\120\49\123\120\123\120\48\120\74\120\123\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\74\120\123\120\123\120\123\120\46\120\123\120\123\120\123\120\123\120\123\120\123\120\74\68\120\74\123\120\123\120\123\120\123\120\123','{J1.9I,4`&X;:@)DO#BT]MY5>K%F[|0HU+7*<2LV}3(QP$_?ZW^/NRG86E!=~ACS'),(getfenv and getfenv(0))or _ENV)() end)(...)
