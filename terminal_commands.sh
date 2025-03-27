# 创建新的目录结构
mkdir -p src/{assignment,opening,review,thesis/{frontmatter,mainmatter,backmatter}}
mkdir -p assets/{images,data}
mkdir -p scripts
mkdir -p styles
mkdir -p bibliography

# 移动主文档文件
git mv cuzassignment.tex ./
git mv cuzopening.tex ./
git mv cuzreview.tex ./
git mv cuzthesis.tex ./

# 移动内容文件到新的结构
# 1. 移动任务书、开题报告和文献综述相关文件
git mv contents/assignmentbody.tex src/assignment/
git mv contents/openingbody.tex src/opening/
git mv contents/reviewbody.tex src/review/

# 2. 移动论文前置部分
git mv contents/abstracts.tex src/thesis/frontmatter/
git mv contents/acknowledgement.tex src/thesis/frontmatter/
git mv contents/initialization.tex src/thesis/frontmatter/

# 3. 移动论文主体部分
git mv contents/chapter_introduction.tex src/thesis/mainmatter/
git mv contents/chapter_conclusions.tex src/thesis/mainmatter/
git mv contents/chapter_guidance.tex src/thesis/mainmatter/
git mv contents/mainbody.tex src/thesis/mainmatter/

# 4. 移动论文后置部分
git mv contents/appendices.tex src/thesis/backmatter/

# 5. 移动构建脚本
git mv run.sh scripts/
git mv run.bat scripts/

# 提交更改
git add .
git commit -m "refactor: restructure project layout

- Organize source files into dedicated directories
- Separate different document types
- Move build scripts to scripts/ directory
- Create assets directory for resources
- Maintain all document types support"
