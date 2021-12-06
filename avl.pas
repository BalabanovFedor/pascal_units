unit avl;
interface
    type
        TE=integer;
        pTE=^TE;
        pTree=^avl_tree;
        avl_tree=record key:integer;
                        left, right: pTree;
                        info: pTE; 
                        depth: integer;
        end;
    function find(pt: pTree; k:integer): pTree;
    { find возвращает ссылку на элемент с искомым ключом, 
      если такого элемента нет, то возвращает nil }

    function form(var pt:pTree; k:integer): pTree;
    { form вставляет элемент с ключом k в дерево, если его там не было,
      возвращает ссылку на элемент с ключом k }

    procedure del(var pt:pTree; k: integer);
    { del удаляет элемент с ключом k,если он там есть }

implementation

procedure dSons(var l, r:integer; pt:pTree);
    { возвращает высоту дочерних элементов }
    begin
        l:=0; r:=0;
        if pt<>nil then
            with pt^ do begin
                if left <> nil then l:=left^.depth;
                if right <> nil then r:=right^.depth;
            end;
    end;

function getBalance(pt:pTree):integer;
    { возвращает баланс элемента }
    var l, r:integer;
    begin
        dSons(l, r, pt);
        getBalance:= r-l
    end;

procedure updateDepth(pt:pTree);
    { обновляет значение depth в корне переданого дерева }
    var l, r:integer;
    begin
        dSons(l, r, pt);
        if l<r then l:=r;
        if pt<>nil then pt^.depth:=l+1
    end;

procedure link(var A, B, C:pTree);
    { прикрепляет к А соответственно слева и справа B и C }
    begin
        A^.left:= B;
        A^.right:= C
    end;

procedure getSons(var A, B, C: pTree);
    { передает в B и C левую и правую дочерние ветки A соответственно }
    begin
        B:=A^.left;
        C:=A^.right
    end;

function RL(var root: pTree):boolean;
    var a, b, c, a1, b1, c1, b2: pTree;
    begin
        a:=root; RL:=false;
        if getBalance(a)=2 then
            if getBalance(a^.right) = -1 then begin
                getSons(a, a1, c);
                getSons(c, b, c1);
                getSons(b, b1, b2);

                link(a, a1, b1); updateDepth(a);
                link(c, b2, c1); updateDepth(c);
                link(b, a, c); updateDepth(b);

                root:=b; RL:=true
            end;
    end;

function RR(var root: pTree):boolean;
    var a, b, c, a1, b1: pTree;
    begin
        a:=root; RR:=false;
        if getBalance(a)=2 then
            if getBalance(a^.right) = +1 then begin
                getSons(a, a1, b);
                getSons(b, b1, c);

                link(a, a1, b1); updateDepth(a);
                link(b, a, c); updateDepth(b);

                root:=b; RR:=true
            end;
    end;

function LL(var root: pTree):boolean;
    var a, b, c, b1, c1: pTree;
    begin
        c:=root; LL:=false;
        if getBalance(c)=-2 then
            if getBalance(c^.left) = -1 then begin
                getSons(c, b, c1);
                getSons(b, a, b1);

                link(c, b1, c1); updateDepth(c);
                link(b, a, c); updateDepth(b);

                root:=b; LL:=true
            end;
    end;

function LR(var root: pTree):boolean;
    var a, b, c, a1, b1, c1, b2: pTree;
    begin
        c:=root; LR:=false;
        if getBalance(c)=-2 then
            if getBalance(c^.left) = 1 then begin
                getSons(c, a, c1);
                getSons(a, a1, b);
                getSons(b, b1, b2);

                link(a, a1, b1); updateDepth(a);
                link(c, b2, c1); updateDepth(c);
                link(b, a, c); updateDepth(b);

                root:=b; LR:=true
            end;
    end;

procedure born(var pt:pTree; k:integer);
    begin
        new(pt);
        with pt^ do begin
            key:=k;
            left:= nil; right:=nil;
            info:=nil;
        end
    end;

function find(pt: pTree; k:integer): pTree;
    begin
        if pt=nil then find:=nil
        else with pt^ do
            if key=k then find:=pt
            else if key<k then find:=find(right, k)
            else find:=find(left, k)
    end;

function form(var pt:pTree; k:integer): pTree;
    begin
        if pt=nil then begin
            born(pt, k);
            pt^.depth:=1
        end;
        with pt^ do
            if key=k then form:=pt
            else if key<k then form:=form(right, k)
            else form:=form(left, k);
        if not LL(pt) then
        if not LR(pt) then
        if not RR(pt) then
        if not RL(pt) then updateDepth(pt)
    end;

function mKrest(var R : pTree; S : pTree) : pTree;
    { непосредственное удаление из памяти элемента R^, 
      S - элемент ссылающийся на R }
    var X,Y,U,W : pTree;
    begin 
        X:=R^.left;
        Y:=R^.right;
        if R^.info <> nil then dispose(R^.info);
        dispose(R);
 { m1 } if (X = nil) and (Y = nil) then begin R:=nil; mKrest:=S end
 { m2 } else if X = nil then begin R:=Y; mKrest:=S end
 { m3 } else if Y = nil then begin R:=X; mKrest:=S end
 {m4.1} else if X^.Right = nil then begin R:=X; mKrest:=R; R^.right:=Y end
 {m4.2} else begin
            U:=X;
            while U^.right^.right <> nil do U:=U^.right;
            R:=U^.right;
            W:=R^.left; 
            U^.right:=W; { ! }
            R^.left:=X; 
            R^.right:=Y;
            mKrest:=U
        end
    end;

function mKill(var pt:pTree; k:integer; s:pTree):pTree;
    { поиск элемента с ключом k, который подлежит удалению,
      s - предыдущий перед pt }
    begin
        if pt=nil then mKill:=nil
        else with pt^ do 
            if key=k then mKill:=mKrest(pt, s)
            else if key<k then mKill:=mKill(right, k, pt)
            else mKill:=mKill(left, k, pt)
    end;

procedure del(var pt:pTree; k: integer);
    var e, w, fict: pTree;
    begin
        if pt=nil then Exit;
        new(fict);
        e:=mKill(pt, k, fict);
        if pt<>nil then
            if e<> nil then
                if e=fict then w:=form(pt, pt^.key)
                else w:=form(pt, e^.key)
    end;


end.