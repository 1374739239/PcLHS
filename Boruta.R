#参考链接：https://mp.weixin.qq.com/s?__biz=MzI5MTcwNjA4NQ==&mid=2247510887&idx=1&sn=6056ed529e0c340e969eea93d2c93c42&cur_album_id=1688898593245462537#wechat_redirect
#加载包
library(Boruta)
library(openxlsx)
library(dplyr)
#加载数据
data = read.xlsx("E:/Frence_0129/sample and area/共线性检验后数据/trainev.xlsx") 
#自变量与因变量的划分
x = model.matrix(lnsoc~.,data = data)[,-1]
#先运行完x，在判断x2的取值范围（主要是排除坐标的影响）
x2= x[,1:27]
y = data$lnsoc
#boruta算法
#结果好像更稳定，不容易受到seed值得影响
#设置随机种子保证结果的可重复性
set.seed(10)
#x和y分别是预测变量和响应变量，
#maxRuns:Boruta进行迭代的最多次数，相当于建立多少个随机森林。注意这里不是随机森林里面的决策树的数量
#maxRuns = 500,计算importance的最大迭代次数，当要保留暂时属性时（Tentative feature）应提高该值。
#doTrace：它指的是详细程度。0指不跟踪。1指一旦属性被清除就作出报告决定。2意味着所有的1另加上报告每一次迭代。默认为0。此处选择2可明示重要变量、拒绝变量的内容
#getImp = getImpRfZ，用来衡量属性重要性的计算方法，默认使用随机森林整合平均下降精度的Z-scores，该值越大说明该属性越重要。
#迭代次数设置为1w的原因是：1存在暂时性变量TRI需要剔除
boruta <- Boruta(x2, y, pValue=0.01, mcAdj=T, maxRuns=10000,doTrace=1,getImp = getImpRfZ)
#查看整体的运行结果
boruta
#绘制变量重要性判读结果图，绿色为重要，红色为拒绝，蓝色为影子变量，黄色为暂时变量
#las标识横坐标和纵坐标刻度标签的排列方式,取值0,1,2,3。取值为2表示横纵坐标刻度标签分别垂直于各自的坐标轴。
plot(boruta,las=2)
# #显示变量重要性判读的结果
# table(boruta$finalDecision)
# #显示重要变量
# boruta.finalVars <- data.frame(Item=getSelectedAttributes(boruta, withTentative = F), Type="Boruta")
# # 查看是否还需要增加迭代次数
##绿线对应已确认的特征，红色表示被拒绝的特征，黄色表示待确定的特征，蓝色分别表示最小、平均和最大阴影特征的重要性
#plotImpHistory(boruta)
# #获取重要变量的结果，对于暂时重要变量也予以剔除
getSelectedAttributes(boruta, withTentative = F)
# 获取变量的具体重要性评分结果
boruta.df <- attStats(boruta)
#print(boruta.df)