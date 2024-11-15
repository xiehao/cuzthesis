# 浙江传媒学院本科毕业设计 LaTeX 模板集

## 概述

* `cuzthesis`为撰写浙江传媒学院本科毕业论文及相关文档（任务书、开题报告、文献综述等）的 LaTeX 模版集。本模板集以国科大 LaTeX 模板[`ucasthesis`](https://github.com/mohuangrui/ucasthesis)为基础，按浙江传媒学院毕业设计 Word 模板格式修改而成，在此向国科大模板制作者莫晃锐及其他相关人士表示衷心感谢！
* 本模板集兼顾了Linux、macOS与Windows三大系统平台，以及`pdfLaTeX`、`LuaLaTeX`与`XeLaTeX`三大编译引擎（有部分引擎在部分系统下暂不支持或支持不够好，故主要推荐`LuaLaTeX`与`XeLaTeX`，后者尤佳）；此外，更建议直接利用在线平台（如[TeX Page](https://www.texpage.com)）进行构建（因[overleaf](https://www.overleaf.com)平台缺乏**隶书**与**魏碑**两种字体，故暂不推荐）。
* 本模板集已将 LaTeX 的复杂性尽可能高度封装，留给用户一个简单的接口，结合说明文档`guidance.pdf`，经简单训练应可上手。

## 用法

1. 直接下载本仓库为`.zip`压缩包，并将其上传至在线 LaTeX 编译平台（如[TeX Page](https://www.texpage.com)）；
2. 打开项目并进行如下设置：
   - 强烈建议选择`XeLaTeX`编译器；
   - 尽量选择最新版`TeX Live`编译套件；
   - 按需选择主编译文件：
     | 文档类型 | 应选文件            |
     | -------: | ------------------- |
     |   任务书 | `cuzassignment.tex` |
     | 开题报告 | `cuzopening.tex`    |
     | 文献综述 | `cuzreview.tex`     |
     |     论文 | `cuzthesis.tex`     |
3. **仅**需按要求修改部分文件即可，分别解释如下：
   - 任务书：
     - `contents/assignmentbody.tex`：任务书正文；
   - 开题报告：
     - `contents/openingbody.tex`：开题报告正文；
   - 文献综述：
     - `contents/reviewbody.tex`：文献综述正文；
   - 论文：
     - `contents/abstracts.tex`：论文中英文摘要；
     - `contents/chapter_*.tex`：论文正文各章节，必要时可仿照已有文件自行添加；
     - `contents/mainbody.tex`：论文正文，间接包含各章节，新增章节时须同步更新；
     - `contents/acknowledgement.tex`：论文致谢；
     - `contents/appendices.tex`：论文附录（可选，若无则应删除主文档`cuzthesis.tex`中的相关导入语句）；
   - 其他：
     - `contents/initialization.tex`：记录各种信息（如毕设题目、作者信息、导师信息等），以便在其他文档中引用，使得数据在多文档之间保持一致；
     - `bibliography/references.bib`：参考文献数据库，将待引用参考文献的`BiBTeX`格式信息录入该文件，即可在各文档正文中引用；
4. 在完成撰写各文档后，可分别导出并下载生成的`.pdf`文档，同时也建议导出并下载整个工程。