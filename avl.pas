unit avl;
interface
    type
        TE=record ... end;
        pTE=^TE;
        pTree=^avl_tree;
        avl_tree=record key:integer;
                        left, right: pTree;
                        info: pTE; 
                        depth: integer;
        end;
    function find(pt: pTree; key:integer): pTree;
    function add(var pt:pTree; k:integer): pTree;
    procedure del(var pt:pTree; k: integer);

implementation

type
    TE=record ... end;
    pTE=^TE;
    pTree=^avl_tree;
    avl_tree=record key:integer;
                    left, right: pTree;
                    info: pTE; 
                    depth: integer;
    end;

procedure DepthSons(var l, r:integer; pt:pTree);

function getBalance(pt:pTree):integer;

procedure updateDepth(pt:pTree);



function find(pt: pTree; key:integer): pTree;
function add(var pt:pTree; k:integer): pTree;
procedure del(var pt:pTree; k: integer);    


end.