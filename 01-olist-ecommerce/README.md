# Olist 巴西电商综合运营分析

## 项目概述

本项目基于 Kaggle 公开数据集 [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/olistbr/brazilian-ecommerce)，对巴西最大电商平台 Olist 进行全面的业务分析。项目涵盖数据清洗、探索性数据分析（EDA）、RFM 用户分层、高价值用户预测建模以及 Tableau 可视化仪表板搭建，形成了一套完整的电商数据分析解决方案。

## 分析框架

### 1. 业务经营综合分析

- **销售走势与淡旺季分析**：分析平台整体销售趋势，识别销售旺季与淡季
- **商品品类分析**：挖掘热销品类，为库存备货提供数据支撑
- **地域分析**：识别高购买力城市，辅助市场投放与物流布局决策
- **支付方式分析**：分析用户支付偏好，为支付渠道策略提供参考
- **用户评价分析**：分析评分分布与低分原因，评估整体用户满意度
- **商家地域分布**：分析头部商家集中区域，了解平台供给端结构

### 2. RFM 用户价值分层

基于 RFM 模型对用户进行价值分层：

- **R（Recency）**：最近一次购买时间
- **F（Frequency）**：购买频率
- **M（Monetary）**：消费金额

将用户划分为高价值用户、一般用户、低价值用户等层级，为精细化运营提供依据。

### 3. 高价值用户预测模型

基于用户历史行为特征，构建机器学习分类模型，预测用户是否为高价值用户。通过特征重要性排序识别影响用户价值的关键因素。

## 技术栈

| 工具 | 用途 |
|------|------|
| **Python** | 数据处理、RFM 分析、机器学习建模 |
| **Pandas / NumPy** | 数据清洗与特征工程 |
| **Matplotlib** | 可视化图表生成 |
| **SQL** | 多表关联查询与数据提取 |
| **Tableau** | 交互式可视化仪表板搭建 |

## 项目结构

```
01-olist-ecommerce/
├── data/                        # 原始数据集与衍生数据
│   ├── olist_*.csv             # Olist 平台原始数据表（9张）
│   ├── order_master.csv        # 数据清洗后的订单主表
│   ├── product_category_name_translation.csv  # 品类翻译表
│   ├── user_rfm.csv            # RFM 用户分层结果
│   ├── user_ml_result.csv      # 机器学习预测结果
│   └── dataset_source.txt      # 数据来源链接
├── python/
│   └── olist_ecommerce_full_analysis.ipynb  # 完整分析 Jupyter Notebook
├── sql/
│   └── olist_analysis.sql      # SQL 多表关联查询脚本
├── tableau/                     # Tableau 工作簿文件
│   ├── Olist电商销售经营综合分析.twb
│   ├── Olist巴西电商RFM用户价值分层深度分析.twb
│   └── Olist巴西电商用户模型预测效果分析.twb
├── output/
│   ├── python_charts/           # Python 生成的分析图表
│   │   ├── 用户分层结构分布与数量统计.png
│   │   └── 高价值用户预测模型-特征重要性排序.png
│   └── tableau_dashboards/      # Tableau 仪表板截图
│       ├── Olist 电商销售经营综合分析.png
│       ├── Olist 巴西电商 RFM 用户价值分层深度分析.png
│       └── Olist巴西电商用户模型预测效果分析.png
├── requirements.txt             # Python 依赖包列表
├── .gitignore                   # Git 忽略配置
├── LICENSE                      # MIT 开源协议
└── README.md
```

## 核心分析结论

### 销售经营分析
- 平台销售呈逐年增长趋势，存在明显的季节性波动
- 部分品类（如家居用品、健康美容等）持续热销，是平台的核心品类
- 高购买力城市主要集中在东南部地区（圣保罗、里约热内卢等）
- 信用支付是最主流的支付方式，用户偏好分期付款
- 整体评价较高，低分主要集中在物流延迟与商品描述不符

### RFM 用户分层
- 高价值用户占比约 10-15%，贡献了大部分收入
- 多数用户为一次性购买用户，复购率有较大提升空间

### 预测模型
- 模型能有效识别高价值用户，关键预测特征为购买频率、消费金额和评价分数
- 可通过早期行为特征识别潜力用户，支持精准营销

## 使用说明

### 前置依赖

- Python 3.8+
- Jupyter Notebook
- Tableau Desktop（如需查看 .twb 文件）

### Python 依赖安装

```bash
pip install -r requirements.txt
```

### 运行步骤

1. **Python 分析**：打开 `python/olist_ecommerce_full_analysis.ipynb`，按序执行单元格即可复现完整分析流程
2. **SQL 查询**：`sql/olist_analysis.sql` 为数据探索阶段的 SQL 查询脚本，可直接在 MySQL/PostgreSQL 等数据库中运行
3. **Tableau 仪表板**：使用 Tableau Desktop 打开 `tableau/` 目录下的 `.twb` 文件，查看交互式可视化分析

### 数据说明

数据集来自 Kaggle，包含 2016-2018 年约 10 万条订单数据，涵盖订单、用户、商品、商家、评价、支付等多个维度，是一个模拟真实电商业务场景的多表数据集。

## 能力展示

- **完整的数据分析闭环**：从数据清洗、探索性分析、特征工程到建模预测和可视化展示，覆盖数据分析全流程
- **多工具协同**：综合运用 Python、SQL、Tableau 三种数据分析工具，体现多维度技术能力
- **业务导向分析**：从销售、用户、商品、地域等多个业务视角出发，输出可落地的商业洞察
- **机器学习应用**：将分类模型应用于用户价值预测，展示数据科学建模能力
- **可视化呈现**：通过 Tableau 构建交互式仪表板，将分析结论直观呈现给决策者