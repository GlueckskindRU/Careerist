//
//  CellIdentifiers.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 27/08/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import Foundation

enum CellIdentifiers: String {
    case characteristicCellLevel0 = "Characteristic Cell Level 0"
    case characteristicCellLevel1 = "Characteristic Cell Level 1"
    case characteristicCellLevel2 = "Characteristic Cell Level 2"
    case characteristicArticleCell = "Characteristics Article Cell"
    case characteristicCell = "Characteristic Cell"
    case completenceCell = "Competence Cell"
    case indicatorCell = "Indicator Of Competence Cell"
    //articles inside
    case insideCell = "Element Inside Cell"
    case listElementCell = "List Element Cell"
    case articleTestAnswersCell = "Article Test Question Answers Cell"
    //article preview
    case articleTextCell = "Article Text Cell"
    case articleTextWithCaptionCell = "Article Text With Caption Cell"
    case articleImageCell = "Article Image Cell"
    case articleImageWithCaptionCell = "Article Image With Caption Cell"
    case articleListCell = "Article List Cell"
    case articleListWithCaptionCell = "Article List With Caption Cell"
    //Advices + Competencies
    case receivedCompetenciesCell = "Received Competencies Cell"
    case listOfAdvicesCell = "List Of Advices Cell"
    case listOfArticlesCell = "List of Articles Cell"
    //Schedule
    case articlesSchedule = "Articles Schedule Cell"
    case advicesSchedule = "Advices Schedule Cell"
    //Answers for questions
    case answersOptionCell = "Answer Cell"
    //Achievements
    case achievementsCell = "Achievement Cell"
    //Notes
    case notesCell = "Notes Cell"
}
