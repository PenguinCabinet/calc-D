import std.stdio;
import std.conv;
import std.range, std.algorithm;

int[string] op_priority;

void init_op_priority(){
    op_priority=["*":1,"/":1,"+":2,"-":2,"(":3,")":3];
}

string[] expr_tokenizer(string v){
    string[] A;
    A.length=1;
    auto Is_prev_number=false;
    foreach (i,e; v)
    {
        if(to!string(e) in op_priority){
            if(Is_prev_number){
                A.length++;
            }
            Is_prev_number=false;
            A[$-1]=to!string(e);
            A.length++;
        }else{
            A[$-1]~=to!string(e);
            Is_prev_number=true;
        }
    }
    return A;
}

unittest
{
    init_op_priority();
    assert(
        expr_tokenizer("1+1") == ["1","+","1"]
    );
    assert(
        expr_tokenizer("111+1") == ["111","+","1"]
    );
    assert(
        expr_tokenizer("111+1*3") == ["111","+","1","*","3"]
    );
    assert(
        expr_tokenizer("(111+1)/33") == ["(","111","+","1",")","/","33"]
    );
}

string[] expr_to_RPB(string[] v){
    string[] A;
    string[] stack;
    foreach (e; v)
    {
        if(e in op_priority){
            if(e=="("){
                stack~=e;
            }else if(e==")"){
                if(stack.splitter("(").array().length==0){
                    continue;
                }
                auto temp=
                stack.splitter("(").array()[$-1]
                .filter!(e => e!="("&&e!=")").array();
                temp.reverse;
                A~=temp;
                stack=stack.splitter("(").array()[0..$-1].joiner().array();
            }else{
                if(!stack.empty&&op_priority[stack[$-1]]<=op_priority[to!string(e)]){
                    A~=stack[$-1];
                    stack.length--;
                }
                stack~=e;
            }
        }else{
            A~=e;
        }
    }
    if(!stack.empty){
        stack.reverse;
        A~=stack;
    }
    /*
    foreach (e; A)
	    writef("%s ",e);
    writeln();
    */
    return A.filter!(e => e!="").array();
}

unittest
{
    init_op_priority();
    assert(
        expr_to_RPB(expr_tokenizer("1+1"))
        == 
        "1 1 +".splitter(' ').array()
    );
    assert(
        expr_to_RPB(expr_tokenizer("111+1"))
        == 
        "111 1 +".splitter(' ').array()
    );
    assert(
        expr_to_RPB(expr_tokenizer("111+1*3"))
        == 
        "111 1 3 * +".splitter(' ').array()
    );
    assert(
        expr_to_RPB(expr_tokenizer("(111+1)/33"))
        == 
        "111 1 + 33 /".splitter(' ').array()
    );
    assert(
        expr_to_RPB(expr_tokenizer("(1+(111+1*3)*3+((4/45)))/33"))
        == 
        "1 111 1 3 * + 3 * 4 45 / + + 33 /".splitter(' ').array()
    );
}

long eval_RPB(string[] v){
    long[] stack;
    foreach (e; v)
    {
        if(e in op_priority){
            long node1;
            if(stack.length>=2){
                node1=stack[$-2];
            }else{
                node1=0L;
            }
            long node2=stack[$-1];
            long temp;
            switch(e){
                case "+":
                temp=node1+node2;
                break;
                case "-":
                temp=node1-node2;
                break;
                case "*":
                temp=node1*node2;
                break;
                case "/":
                temp=node1/node2;
                break;
                default:
                break;
            }
            if(stack.length>=2){
                stack=stack[0..$-2];
            }else{
                stack=stack[0..$-1];
            }
            stack~=temp;
        }else{
            stack~=parse!long(e);
        }
    }

    return stack[0];
}

unittest
{
    init_op_priority();
    assert(
        eval_RPB(expr_to_RPB(expr_tokenizer("1+1")))
        == 
        long(1+1)
    );
    assert(
        eval_RPB(expr_to_RPB(expr_tokenizer("111+1")))
        == 
        long(111+1)
    );
    assert(
        eval_RPB(expr_to_RPB(expr_tokenizer("111+1*3")))
        == 
        long(111+1*3)
    );
    assert(
        eval_RPB(expr_to_RPB(expr_tokenizer("(111+1)/33")))
        == 
        long((111+1)/33)
    );
    assert(
        eval_RPB(expr_to_RPB(expr_tokenizer("(1+(111+1*3)*3+((4/45)))/33")))
        == 
        long((1+(111+1*3)*3+((4/45)))/33)
    );
    assert(
        eval_RPB(expr_to_RPB(expr_tokenizer("1+2+3*(4+5*2)")))
        == 
        long(1+2+3*(4+5*2))
    );
    assert(
        eval_RPB(expr_to_RPB(expr_tokenizer("1-(0-1)")))
        == 
        long(1-(0-1))
    );
}

void main()
{
    init_op_priority();
    while(true){
        write(">");
        string input_expr=readln[0..$-1];
        if(input_expr=="q")
            break;

        auto tokenized_expr=expr_tokenizer(input_expr);
        writef("tokenized expr:");
        foreach (e; tokenized_expr)
            writef("%s ",e);
        writeln();

        auto RPB_expr=expr_to_RPB(tokenized_expr);
        writef("RPB expr:");
        foreach (e; RPB_expr)
            writef("%s ",e);
        writeln();

        auto result=eval_RPB(RPB_expr);
        writefln("%d",result);
    }
}
