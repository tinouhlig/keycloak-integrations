<?php

namespace App\Controller;

use App\Repository\AccessRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;

class ListAccessController extends AbstractController
{
    public function __construct(
        private readonly AccessRepository $accessRepository,
    ) {
    }

    #[Route('/access', name: 'app_list_access')]
    public function index(): JsonResponse
    {
        return $this->json($this->accessRepository->findAll());
    }
}
