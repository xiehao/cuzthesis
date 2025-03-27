# -*- mode: perl -*- 

# 指定编译器
$pdf_mode = 5;  # 使用 xelatex 生成 PDF
$xelatex = 'xelatex -shell-escape -file-line-error -synctex=1 %O %S';
$lualatex = 'lualatex -shell-escape -file-line-error -synctex=1 %O %S';
$pdflatex = 'pdflatex -shell-escape -file-line-error -synctex=1 %O %S';

# 参考文献编译器
$bibtex_use = 1.5;
$biber = 'biber --bblencoding=utf8 -u -U --output_safechars %O %S';

# 编译次数
$max_repeat = 5;

# 中间文件清理设置
$clean_ext = 'synctex.gz synctex.gz(busy) run.xml tex.bak bbl bcf fdb_latexmk run tdo %R-blx.bib';

# 输出目录设置
$out_dir = 'cache';

# 预览设置（如果需要）
$preview_continuous_mode = 0;
$preview_mode = 0;

# 自定义依赖关系
add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

# 辅助函数
sub run_makeglossaries {
    my ($base_name, $path) = fileparse( $_[0] );
    pushd $path;
    my $return = system "makeglossaries", $base_name;
    popd;
    return $return;
}

# 文件监视设置
$sleep_time = 1;
@generated_exts = (@generated_exts, 'glo', 'gls', 'glg');
@generated_exts = (@generated_exts, 'acn', 'acr', 'alg');

# 编码设置
$ENV{'TEXEDIT'} = 'texworks --position=%d "%s"';
$ENV{'TEXINPUTS'} = './/:./src//:./src/common//:./src/thesis/frontmatter//:./src/thesis/mainmatter//:./src/thesis/backmatter//:' . $ENV{'TEXINPUTS'};
$ENV{'BIBINPUTS'} = './bibliography//:' . $ENV{'BIBINPUTS'};
$ENV{'BSTINPUTS'} = './bibliography//:' . $ENV{'BSTINPUTS'};
